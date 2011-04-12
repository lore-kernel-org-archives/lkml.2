Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809Ab1DLPrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 11:47:18 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58198 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583Ab1DLPrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 11:47:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=jH9QaVYtKb7pvEe3N6UtMhVEBIsQLqicEnwRVqoGK1GpIERTO8LKvs7YbIKQCrSZdp
         wXhE9pWrlqY3shl1ShQalj6CYdRWNpRDdpVYDszmOGgUaQTeVJaknaPhcTCZr4ZJBPHE
         okoEe/Xrm9wCne4YL2BHXk3kqFgSGQDMg/TYQ=
Message-ID: <4DA473FE.2040800@gmail.com>
Date: Tue, 12 Apr 2011 08:47:10 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Mikko Vinni <mmvinni@yahoo.com>, Ed Tomlinson <edt@aei.ca>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        linux-kernel@vger.kernel.org
Subject: Re: 2.6.38 kernel breaks userspace bluetooth management tools
References: <AANLkTikdco2Ex_xEAgWyOQ9OytQkTqR90Nh2hOnneXSu@mail.gmail.com> <loom.20110319T223719-154@post.gmane.org> <20110411214416.GB25899@kroah.com>
In-Reply-To: <20110411214416.GB25899@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2011 02:44 PM, Greg KH wrote:
> On Sat, Mar 19, 2011 at 09:46:03PM +0000, Mikko Vinni wrote:
>> İsmail Dönmez<ismail<at>  namtrac.org>  writes:
>>> According to http://www.bluez.org/the-management-interface/ bluetooth
>>> management interface has changed in the 2.6.38 kernel and this ends up
>>> breaking bluetooth management tools (the ones that get your bluetooth
>>> mouse working) in both KDE&  Gnome ( see
>>> https://bugzilla.novell.com/show_bug.cgi?id=680170 ).
>>
>> This sounds like http://www.spinics.net/lists/linux-bluetooth/msg10695.html
>>
>> The fix is on its way. Nothing is deliberately broken.
>>
>> http://git.kernel.org/?p=linux/kernel/git/padovan/bluetooth-next-2.6.git;a=commitdiff;h=b99faf1b798d6d0e33526fd2cef55a405c08ff09;hp=58b6e124aac64bebb2e9e1a136cbd21a5ab0485a
>
> That fix isn't in the -stable tree, and doesn't apply cleanly to the
> .38-stable tree.
>
> Can someone provide a backport to stable@kernel.org?
>
> thanks,
>
> greg k-h
>


o.k my diff skills sucks, but(hopefully) backported correctly, sent out 
to stable@kernel.org..

let me know if you get this or not(seems gmail is not showing my sent 
mail)..

Justin P. Mattock
