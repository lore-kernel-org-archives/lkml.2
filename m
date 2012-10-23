Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684Ab2JWI6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 04:58:45 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:49386 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503Ab2JWI6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 04:58:43 -0400
MIME-Version: 1.0
In-Reply-To: <20121023085448.GM5635@localhost>
References: <508296B4.60508@gmail.com>
	<20121023085448.GM5635@localhost>
Date: Tue, 23 Oct 2012 10:58:42 +0200
Message-ID: <CANGUGtB0VR4hnRf5hk3_7Rc23fo5ejtj3J2yZZ50tD_Tk+sigw@mail.gmail.com>
Subject: Re: [PATCH 06/21] ocfs2: drop vmtruncate
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Marco Stornelli <marco.stornelli@gmail.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/23 Joel Becker <jlbec@evilplan.org>:
> On Sat, Oct 20, 2012 at 02:19:00PM +0200, Marco Stornelli wrote:
>> Removed vmtruncate
>>
>> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
>
> Acked-by: Joel Becker <jlbec@evilplan.org>
>
> Do you want me to pull this, or are you going to send it with your set?
>
> Joel
>

I'd prefer to push all via Al's tree since there is a VFS change.

Marco
