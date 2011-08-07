Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab1HGAVD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 20:21:03 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:58966 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753459Ab1HGAVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 20:21:00 -0400
Date: Sat, 6 Aug 2011 17:20:58 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Paul Mcquade <paulmcquad@gmail.com>
Cc: linux-doc <linux-doc@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Email-clients: Add better Thunderbird information.
Message-Id: <20110806172058.a5deeb72.rdunlap@xenotime.net>
In-Reply-To: <4E3C78AC.6040509@gmail.com>
References: <4E3C78AC.6040509@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 06 Aug 2011 00:11:40 +0100 Paul Mcquade wrote:

> ---
>  Documentation/email-clients.txt |   12 +++++-------
>  1 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/email-clients.txt b/Documentation/email-clients.txt
> index a0b58e2..860c29a 100644
> --- a/Documentation/email-clients.txt
> +++ b/Documentation/email-clients.txt
> @@ -199,18 +199,16 @@ to coerce it into behaving.
>  
>  To beat some sense out of the internal editor, do this:
>  
> -- Under account settings, composition and addressing, uncheck "Compose
> -  messages in HTML format".
> -
>  - Edit your Thunderbird config settings so that it won't use format=flowed.
>    Go to "edit->preferences->advanced->config editor" to bring up the
>    thunderbird's registry editor, and set "mailnews.send_plaintext_flowed" to
>    "false".
>  
> -- Enable "preformat" mode: Shft-click on the Write icon to bring up the HTML
> -  composer, select "Preformat" from the drop-down box just under the subject
> -  line, then close the message without saving.  (This setting also applies to
> -  the text composer, but the only control for it is in the HTML composer.)
> +- Disable HTML Format: Set "mail.identity.id1.compose_html" to "false".
> +
> +- Enable "preformat" mode: Set "editor.quotesPreformatted" to "true".
> +
> +- Enable UTF8: Set "prefs.converted-to-utf8" to "true".
>  
>  - Install the "toggle wordwrap" extension.  Download the file from:
>      https://addons.mozilla.org/thunderbird/addon/2351/
> -- 1.7.4.1


Applied, thanks.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
