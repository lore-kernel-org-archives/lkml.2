Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061Ab0DRLPP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 07:15:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59385 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833Ab0DRLPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 07:15:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=IwJwmvHQDE8XvxleKxjFBnsxRraeewsXuF+M2qXjx6RolD0lyFz/ejWvofm7ZtX8cI
         iTaMeU3dKUyaqTKW0oxtNNwveS0K91Fp66DVsPYUC19Fnc3gcckqRu0rm2QsVFC9xAfu
         Fy+1NmJ5iXBq6QF45iFP7XP5DDTzqLYVbFq9Y=
Message-ID: <4BCAE9BC.3090609@gmail.com>
Date: Sun, 18 Apr 2010 14:15:08 +0300
From: Oleg Kutkov <elenbert@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Network activity after route changes
References: <4BC9DB9A.9090605@gmail.com>
In-Reply-To: <4BC9DB9A.9090605@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.
I try to send and receive ethernet packets on very low level in my 
kernel module.
When i change (add or delete entry) routin table (via route command) my 
network is freeze for ~15 seconds and my application can't send and 
receive any packets.
Is it normal or bug somewhere in my application?
Can i change this behavior of route system? Maybe change some timeouts, 
or immediately flush route (rt_flush() ?) table?

Thanks.
