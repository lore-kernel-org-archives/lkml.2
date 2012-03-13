Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589Ab2CMSCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 14:02:19 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54600 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab2CMSCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 14:02:17 -0400
Message-ID: <4F5F8B8A.7080300@gmail.com>
Date: Tue, 13 Mar 2012 19:01:46 +0100
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Artem S. Tashkinov" <t.artem@lycos.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Is bugzilla's SSL certificate invalid?
References: <197377679.301107.1331660231517.JavaMail.mail@webmail07>
In-Reply-To: <197377679.301107.1331660231517.JavaMail.mail@webmail07>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Op 13-03-12 18:37, Artem S. Tashkinov schreef:
> Hi,
>
> Some of my web browsers (google chrome and opera) say that the bugzilla's SSL certificate is invalid.
>
> "The site's security certificate is not trusted!
>
> You attempted to reach bugzilla.kernel.org, but the server presented a certificate issued by
> an entity that is not trusted by your computer's operating system. This may mean that the
> server has generated its own security credentials, which Google Chrome cannot rely on for
> identity information, or an attacker may be trying to intercept your communications. You
> should not proceed, especially if you have never seen this warning before for this site."
>
>From the error message, I'd have to guess your browser
doesn't recognise thawte as CA, that's all. Firefox validates
the certificate just fine.

~Maarten
