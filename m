Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab2CIJPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 04:15:07 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59730 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab2CIJPE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 04:15:04 -0500
MIME-Version: 1.0
In-Reply-To: <4F59A69E.1040002@csamuel.org>
References: <CADDYkjQHvmfhmsdt7K0O74DZK6BVqxPaWh_jEi8uJ_HBEz-QhQ@mail.gmail.com>
	<20120308155211.GF4334@twin.jikos.cz>
	<CADDYkjTG-q5+pFRFt9sGKq=cgL=ZgQaNZV=2ipBsSbuvxCa3jw@mail.gmail.com>
	<4F595D6D.6080809@cn.fujitsu.com>
	<4F59A69E.1040002@csamuel.org>
Date: Fri, 9 Mar 2012 10:15:02 +0100
Message-ID: <CADDYkjRW6QLk9sQdsgzQLUS6zLSFURpm=xSuhNArvqdBp=V_cg@mail.gmail.com>
Subject: Re: kernel BUG at fs/btrfs/delayed-inode.c:1466!
From: Jacek Luczak <difrost.kernel@gmail.com>
To: Chris Samuel <chris@csamuel.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/9 Chris Samuel <chris@csamuel.org>:
> On 09/03/12 12:31, Liu Bo wrote:
>
>> So are these warnings based on the latest upstream of btrfs?
>
> Looks like it was 3.2.7, his oops said:
>
> Pid: 1488, comm: mips-wrs-linux- Tainted: G        W    3.2.7 #2 HP

Yep, that's 3.2.7. Now I can't upgrade to latest upstream. As sson as
btrfs CI tests will finish I can go to latest upstream version.

-Jacek
