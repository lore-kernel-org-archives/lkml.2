Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997Ab1JGMqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 08:46:46 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36851 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759951Ab1JGMqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 08:46:45 -0400
MIME-Version: 1.0
In-Reply-To: <20111007113820.3b8424a8@lxorguk.ukuu.org.uk>
References: <1317943022.1095.25.camel@mop> <20111007111231.6e11d18e@lxorguk.ukuu.org.uk>
 <CAPXgP12nDB2NX6hZabmkUZA9n0PZadi6Yv70LNms8fz9+MnVoA@mail.gmail.com> <20111007113820.3b8424a8@lxorguk.ukuu.org.uk>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 7 Oct 2011 14:46:23 +0200
Message-ID: <CAPXgP11K4_eVn4_emEYVzCVUsm-BXDyStk7DnDmFpMTL=404Gg@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_A_Plumber=E2=80=99s_Wish_List_for_Linux?=
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, lennart@poettering.net, harald@redhat.com,
        david@fubar.dk, greg@kroah.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[]sorry, need to resend. I tried to reply with the cell phone but it bounces]

On Fri, Oct 7, 2011 at 12:38, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Fri, 7 Oct 2011 12:28:46 +0200 Kay Sievers <kay.sievers@vrfy.org> wrote:
>
>> What do you mean would be ugly?
>
> I have an ext4fs. It supports every possible file name allowed by POSIX
> and SuS. What name are you going to use for your 'hidden directory' that
> won't clash with a real file ?

Ah, no. The label on FAT (similar on NTFS) are 'magic entries' in the
root dir list, not a real file in the root dir.

We need kernel support for changing a mounted fs, because, unlike
ext4, the blocks containing the strings are inside the fs, which the
kernel might change any time.

Kay
