Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab0LEOfT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 09:35:19 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37961 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991Ab0LEOfS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 09:35:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=VMcgDCRc8T7DsFkks+ILSLYqHQf5RdlipJCFpe3cVZm6VWzmKS0O9vc5Q6USWKOStS
         12fCvcHBgRlEO3LewYWRZoKQSmikfOB8Yunk/3MLfyFGfSU2i1Yi6t30ykTtgtGLnKyn
         4q8d/yPa4OHhGOdnbZBI7npxd4V/EJvZBYTvk=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: kdump broken on 2.6.37-rc4
Date: Sun, 5 Dec 2010 15:35:12 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4; KDE/4.4.5; i686; ; )
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20101203111623.GA2741@redhat.com>
In-Reply-To: <20101203111623.GA2741@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201012051535.12700.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On piątek, 3 grudnia 2010 o 12:16:38 Stanislaw Gruszka wrote:
> On my T-60 laptop, i686 system with 2.6.37-rc4 kernel,
> "echo c > /proc/sysrq-trigger" just hung the system. Kdump
> works on 2.6.36. Is this known issue? If not, what info
> I should provide to solve it (I think the easiest way
> to solve the problem would be bisect) ?
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=24372
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
