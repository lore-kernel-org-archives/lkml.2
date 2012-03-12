Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab2CLLuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 07:50:55 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34363 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab2CLLuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 07:50:50 -0400
MIME-Version: 1.0
In-Reply-To: <4EAF753B-6FBF-4EB8-A200-C7BCE7FDEEA0@gmx.ch>
References: <2C80D678-F219-4B4E-A7FB-D0F890ECC7DD@gmx.ch>
	<CAJd=RBBnxKa+roD+G-G_bnVLBKCmw-wtW+pO8BtQRVmPkRoJpw@mail.gmail.com>
	<4EAF753B-6FBF-4EB8-A200-C7BCE7FDEEA0@gmx.ch>
Date: Mon, 12 Mar 2012 19:50:49 +0800
Message-ID: <CAJd=RBC=iWSSZMmqSc0US9rL0msTDMfm95wmuh_mzYGwGRbFfA@mail.gmail.com>
Subject: Re: bug in thread_group_times (+possible patch)
From: Hillf Danton <dhillf@gmail.com>
To: Fawzi Mohamed <fawzi@gmx.ch>
Cc: linux-kernel@vger.kernel.org, Thomas Dargel <td@chemie.hu-berlin.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2012 at 11:19 PM, Fawzi Mohamed <fawzi@gmx.ch> wrote:
>
> I just tested and div64_u64 was already available.

Looks  ready to send a patch to LKML
