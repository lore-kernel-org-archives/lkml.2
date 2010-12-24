Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab0LXPpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 10:45:53 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34418 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161Ab0LXPpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 10:45:52 -0500
Subject: Re: [RFC][PATCH 1/6] encrypted-keys: fixed valid_master_desc()
 function description
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Gianluca Ramunno <ramunno@polito.it>,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>, kirkland@canonical.com
In-Reply-To: <201012231833.59016.roberto.sassu@polito.it>
References: <201012231833.59016.roberto.sassu@polito.it>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Dec 2010 10:45:28 -0500
Message-ID: <1293205528.3196.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-23 at 18:33 +0100, Roberto Sassu wrote:
> Valid key type prefixes for the parameter 'key-type' are: 'trusted' and
> 'user'.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>

Thanks Roberto!

Acked-by: Mimi Zohar <zohar@us.ibm.com>

> ---
>  security/keys/encrypted_defined.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/security/keys/encrypted_defined.c b/security/keys/encrypted_defined.c
> index 32d27c8..c1c5e27 100644
> --- a/security/keys/encrypted_defined.c
> +++ b/security/keys/encrypted_defined.c
> @@ -84,7 +84,7 @@ static int aes_get_sizes(void)
>  /*
>   * valid_master_desc - verify the 'key-type:desc' of a new/updated master-key
>   *
> - * key-type:= "trusted:" | "encrypted:"
> + * key-type:= "trusted:" | "user:"
>   * desc:= master-key description
>   *
>   * Verify that 'key-type' is valid and that 'desc' exists. On key update,


