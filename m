Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758438Ab1CaPoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:44:25 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:32943 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758245Ab1CaPoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:44:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=aqYgWv4GJ8D/BuEWHHklcUdC6j/2mbVJxfADvXrgt9Dg6xt7rpHMY03O963Xb0XFDQApH3oH9a9YkEsCgUUJkLjzyF6wH9eShGZnbiTT1Nvpdw8u4CusqgMb5Gr07u5E;
Date: Thu, 31 Mar 2011 08:44:20 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Ameya Palande <ameya.palande@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        samu.p.onkalo@nokia.com
Subject: Re: [PATCH] Documentation: Gather led information in one place
Message-Id: <20110331084420.47eaa91c.rdunlap@xenotime.net>
In-Reply-To: <1301579724-29893-1-git-send-email-ameya.palande@nokia.com>
References: <1301579724-29893-1-git-send-email-ameya.palande@nokia.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.42.51 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011 16:55:24 +0300 Ameya Palande wrote:

> Signed-off-by: Ameya Palande <ameya.palande@nokia.com>
> ---
>  Documentation/leds-class.txt       |   98 ------------------------------------
>  Documentation/leds-lp3944.txt      |   50 ------------------
>  Documentation/leds/leds-class.txt  |   98 ++++++++++++++++++++++++++++++++++++
>  Documentation/leds/leds-lp3944.txt |   50 ++++++++++++++++++
>  4 files changed, 148 insertions(+), 148 deletions(-)
>  delete mode 100644 Documentation/leds-class.txt
>  delete mode 100644 Documentation/leds-lp3944.txt
>  create mode 100644 Documentation/leds/leds-class.txt
>  create mode 100644 Documentation/leds/leds-lp3944.txt

Applied, thanks.

Please also create a patch for Documentation/leds/00-INDEX file.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
