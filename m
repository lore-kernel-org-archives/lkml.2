Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab1GEFtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 01:49:55 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:64896 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab1GEFtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 01:49:53 -0400
Message-ID: <4E12A5FC.1010608@gmail.com>
Date: Tue, 05 Jul 2011 08:49:48 +0300
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110626 Icedove/3.1.11
MIME-Version: 1.0
To: linux-ide@vger.kernel.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: SATA EH reset renames device (caused by smart self-tests?)
References: <4E104989.6070702@gmail.com>
In-Reply-To: <4E104989.6070702@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2011 01:50 PM, Török Edwin wrote:
> Hi,
> 
> I got this SATA EH reset on a disk part of RAID, and after recovery it got renamed
> from /dev/sdd to /dev/sdj.  Would've been good if the original name was kept, as it'd have been easier to readd.
> See below for the SATA link reset messages.
> Don't know what that SError is, I've run a SMART short self-test and everything was good, no errors logged.
> 
> While running smartctl -t short I noticed another EH reset though, so could it be that these EH resets
> occur when the drive is a bit busy with running its automatic SMART self-tests?

Apparently this was all due to a loose SATA cable (was plugged in only about 3/4),
plugged it in again, and its working now.

Best regards,
--Edwin
