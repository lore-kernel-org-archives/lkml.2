Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861Ab1DXVc2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 17:32:28 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:36242 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757840Ab1DXVc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 17:32:26 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DB496BE.1080003@verizon.net>
Date: Sun, 24 Apr 2011 17:31:42 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: <linux-kernel@vger.kernel.org>, <uclinux-dist-devel@blackfin.uclinux.org>
Subject: Re: [PATCH] arch: blackfin: use cc-cross-prefix to set CROSS_COMPILE
References: <4DB491D8.6040600@verizon.net> <BANLkTi=j2PgE0PcTF-=dgHMEe_QuSHkxOA@mail.gmail.com>
In-Reply-To: <BANLkTi=j2PgE0PcTF-=dgHMEe_QuSHkxOA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/24/2011 5:19 PM, Mike Frysinger wrote:
> On Sun, Apr 24, 2011 at 17:10, Peter Foley wrote:
>> This patch updates the blackfin Makefile to use cc-cross-prefix
>> to only set CROSS_COMPILE if bfin-uclinux-gcc exists.
> 
> i'm not sure this is useful.  if bfin-uclinux- doesnt exist, it's
> going to use the native gcc, and there is no native gcc for Blackfin
> targets (since it's a nommu arch).  getting a missing bfin-uclinux-gcc
> error is a lot more useful than the native compiler rejecting Blackfin
> insns.
> -mike

Okay, that makes sense.

Peter
