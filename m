Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab0LEIZT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 03:25:19 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56920 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab0LEIZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 03:25:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Lu3XSLSPyITKb4iJ+bisIDyoi+gt95PcBKNxV3zUQnenJyMjvTwn9oaLHNP6UiK0xk
         9tria3PhliUgKPwB2VarVxCGfSFaIIBqjH8RI5FpEBEJii+u+VfNVem/GwbBYKvRkgTc
         nhuNWOW9VagiCTR4UMviwqNPGl+62ig84Nt60=
Message-ID: <4CFB4C66.1090106@gmail.com>
Date: Sun, 05 Dec 2010 09:25:10 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@suse.com>
Subject: Resume hangs [was: mmotm 2010-12-02-16-34 uploaded]
References: <201012030107.oB317ZSW019223@imap1.linux-foundation.org>
In-Reply-To: <201012030107.oB317ZSW019223@imap1.linux-foundation.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2010 01:34 AM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2010-12-02-16-34 has been uploaded to

Hi, this kernel regresses with respect to resume. It doesn't wake up,
the screen is black with blinking cursor at position [1, 1].
2010-11-23-16-12 seemed to be OK. In this one it is 100% reproducible so
far.

I'm using pm-suspend, any ideas what to test before I start to find the
reason on my own?

regards,
-- 
js
