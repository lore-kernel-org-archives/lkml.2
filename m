Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972Ab1DHX6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 19:58:43 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62940 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab1DHX6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 19:58:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HK7DzwjAnVmP6GppMZMj1KU90AWCdF1O3NZGrsGKYF4w5g5qOijafjH59Tui3+Hwti
         FIlhKSliNct9wcgBe1b+awXkGkO7q+cBHUEFhPzxXxhHJt/SoL9qIs0XeAStf4nkOn2J
         vI9NrSEoyLJ15N6HqlrjkYDGGDeUUqaZKh4Bc=
Message-ID: <4D9FA12D.5000803@gmail.com>
Date: Fri, 08 Apr 2011 17:58:37 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        KVM mailing list <kvm@vger.kernel.org>
Subject: Re: trace-cmd errors on kvm events
References: <4D9F59AC.6080707@gmail.com> <4D9F790B.2000300@web.de> <4D9F7A4B.3040606@gmail.com> <4D9F7BC0.8010003@web.de> <4D9F99AA.8060803@gmail.com> <4D9F9D56.2050109@web.de>
In-Reply-To: <4D9F9D56.2050109@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/11 17:42, Jan Kiszka wrote:
> What I also did is updating trace-cmd git and then reinstalling the
> latest plugins: make install_plugins prefix=$HOME. They then end up in
> $HOME/.trace-cmd/plugins. Now I do not have a single error message
> anymore, including that file not found.

Indeed. That did the trick. I was just running out of the build
directory -- without doing an install of any kind.
