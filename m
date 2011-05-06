Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab1EFBJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 21:09:47 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39468 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab1EFBJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 21:09:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ScgI7hzeZeWnbIerDeKtYbuOyhKa+hBBd+6s7G/E+pV3eVD5hdCx2Igw+sTH1bMxLW
         eSY9foX7c3dpUf5wzt0P7UsxWnZxXMhOaA00etdYJGXqWE/PP/q5/iyr9QrKzWJx7iIn
         Ktc7QO56YD3OyUgx4RhcK+LxVE/ZtryMV+MU8=
MIME-Version: 1.0
In-Reply-To: <4DC30FFA.9030708@fastmail.fm>
References: <1304617307-7389-1-git-send-email-tim.gardner@canonical.com>
	<1304617307-7389-2-git-send-email-tim.gardner@canonical.com>
	<4DC30FFA.9030708@fastmail.fm>
Date: Fri, 6 May 2011 04:09:44 +0300
Message-ID: <BANLkTikG=6xyFg--u=M6HwH8yQExAauA8w@mail.gmail.com>
Subject: Re: [PATCH] fbcon -- fix race between open and removal of framebuffers
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: tim.gardner@canonical.com, linux-fbdev@vger.kernel.org,
        lethal@linux-sh.org, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>,
        Leann Ogasawara <leann.ogasawara@canonical.com>,
        Greg KH <gregkh@suse.de>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

@Greg: This is stable material for 2.6.38
link to the patch: http://is.gd/otIfGc
