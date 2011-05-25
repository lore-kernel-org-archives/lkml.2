Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab1EYUEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:04:44 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:33555 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753726Ab1EYUEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:04:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=WKsIzawu9IiuLuvlGPiAojcac6bRfzOqxaMFb88jZ5UKSpQhUlSnueUBSOrYz7O89sydwb+gIV/Zln/p+uC6jItTpxBxfLkwuJ0ZcYAWjwdHJvbGgMGBeq7VSl6FALr1;
Date: Wed, 25 May 2011 13:04:38 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Arend van Spriel" <arend@broadcom.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        "Dan Carpenter" <error27@gmail.com>
Subject: Re: [RFC V1] lib: cordic: add library module for cordic angle
 calculation
Message-Id: <20110525130438.c05605c7.rdunlap@xenotime.net>
In-Reply-To: <1306352426-1899-1-git-send-email-arend@broadcom.com>
References: <1306352426-1899-1-git-send-email-arend@broadcom.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011 21:40:26 +0200 Arend van Spriel wrote:

> diff --git a/include/linux/cordic.h b/include/linux/cordic.h
> new file mode 100644
> index 0000000..28443a6
> --- /dev/null
> +++ b/include/linux/cordic.h
> @@ -0,0 +1,48 @@

> +/**
> + * struct - i/q coordinate.

 * struct cordic_iq - i/q coordinate

> + *
> + * @i: real part of coordinate (in phase).
> + * @q: imaginary part of coordinate (quadrature).
> + */
> +struct cordic_iq {
> +	s32 i;
> +	s32 q;
> +};


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
