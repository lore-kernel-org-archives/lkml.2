Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964798Ab1FWRzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:55:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61592 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932967Ab1FWRzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:55:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=onLh4qOHnUXjT4wTV9MRLCB9BHi3dbCHUhyHvnpYKLZMyX1TUoh3JTcu6n0rpqJf8O
         fF+612Gf4gjF52D0iSVYDPwYF4JOlNUWSPOhxkuV41El06aMzEG465qIrdm79w7ZwUBJ
         ikJ1Dejr/N6RQ6ynDQayEUiOFEixXUdTrVjEU=
MIME-Version: 1.0
In-Reply-To: <20110622063441.GA1740@x4.trippels.de>
References: <20110622063441.GA1740@x4.trippels.de>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 23 Jun 2011 13:54:46 -0400
X-Google-Sender-Auth: jCcW5_nUPTHG4082cC4bWG751RI
Message-ID: <BANLkTimO1xvGUQyUbEPn3U230Hr4-M+RQg@mail.gmail.com>
Subject: Re: __packed vs. __attribute__((packed)) in kernel headers
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 02:34, Markus Trippelsdorf wrote:
> One possible solution would be to let the "scripts/headers_install.pl"
> script automatically substitute __packed with __attribute__((packed)):

until we install compiler.h and friends, this is probably the only way
-mike
