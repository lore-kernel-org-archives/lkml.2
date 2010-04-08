Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948Ab0DHSoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 14:44:34 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:38654 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758802Ab0DHSoc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 14:44:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=M0kh4lOmQUAC41wYLp9FuVa/+0ono/5JuLgyKwQFCmyOfFAUxA2a1HVKZc3d8YgNOg
         hI+CybyhhpoC3u/UhwIKBRI8O/kuKODO+MDJNjzgdXYcvyfJ7O/q+i81OTZPu4igPiq4
         l9q4C14o93Er6OKvDFgah++y4m/1ewZ6LkPms=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: 2.6.34-rc3 doesn't suspend to disk (-rc2 did)
Date: Thu, 8 Apr 2010 20:44:26 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3; KDE/4.3.4; i686; ; )
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <alpine.LNX.2.00.1004020215100.8345@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1004020215100.8345@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004082044.26949.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On piątek, 2 kwietnia 2010 o 02:19:26 Jiri Kosina wrote:
> Hi,
> 
> I have just hit this problem. Haven't bisected it yet, and going through
> shortlog doesn't ring any bell immediately, so I am sending this out in
> case it rings a bell for someone right away.

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=15728
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
