Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604Ab1CSWD4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 18:03:56 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53268 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757544Ab1CSWDx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 18:03:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=namtrac.org; s=www;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Og0SIhWcjYoYbDdLDX8DmzAurMdNcKO9TRGj2brwixm0ILK5RvZds8Ys9OTkk02g4x
         1zKErZkp81HopixQSpMRzGleU6GvDJA6BLaxy4PuRBHvODgY2S5RFn/2y3H8D7xNyMp8
         8M9Erwjmg+VZkH+vCSBEYa4aq1IAadjrEUVyw=
MIME-Version: 1.0
In-Reply-To: <loom.20110319T223719-154@post.gmane.org>
References: <AANLkTikdco2Ex_xEAgWyOQ9OytQkTqR90Nh2hOnneXSu@mail.gmail.com> <loom.20110319T223719-154@post.gmane.org>
From: =?UTF-8?B?xLBzbWFpbCBEw7ZubWV6?= <ismail@namtrac.org>
Date: Sat, 19 Mar 2011 23:03:33 +0100
Message-ID: <AANLkTikzh01ZzbL9Mx5BPDPsAGxyp8uvgQLafwOp12+N@mail.gmail.com>
Subject: Re: 2.6.38 kernel breaks userspace bluetooth management tools
To: Mikko Vinni <mmvinni@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

On Sat, Mar 19, 2011 at 10:46 PM, Mikko Vinni <mmvinni@yahoo.com> wrote:
> İsmail Dönmez <ismail <at> namtrac.org> writes:
>> According to http://www.bluez.org/the-management-interface/ bluetooth
>> management interface has changed in the 2.6.38 kernel and this ends up
>> breaking bluetooth management tools (the ones that get your bluetooth
>> mouse working) in both KDE & Gnome ( see
>> https://bugzilla.novell.com/show_bug.cgi?id=680170 ).
>
> This sounds like http://www.spinics.net/lists/linux-bluetooth/msg10695.html
>
> The fix is on its way. Nothing is deliberately broken.
>
> http://git.kernel.org/?p=linux/kernel/git/padovan/bluetooth-next-2.6.git;a=commitdiff;h=b99faf1b798d6d0e33526fd2cef55a405c08ff09;hp=58b6e124aac64bebb2e9e1a136cbd21a5ab0485a


Great to hear that, thanks!

ismail
