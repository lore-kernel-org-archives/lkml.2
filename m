Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab0HTRNM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 13:13:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33415 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab0HTRNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 13:13:10 -0400
Date: Fri, 20 Aug 2010 10:12:46 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Miloslav =?UTF-8?B?VHJtYcSN?= <mitr@redhat.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, linux-crypto@vger.kernel.org,
        Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/19] User-space API definition
Message-Id: <20100820101246.6c7a3729.randy.dunlap@oracle.com>
In-Reply-To: <1282293963-27807-2-git-send-email-mitr@redhat.com>
References: <1282293963-27807-1-git-send-email-mitr@redhat.com>
	<1282293963-27807-2-git-send-email-mitr@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Aug 2010 10:45:44 +0200 Miloslav Trmač wrote:

> +#define NCRIO_KEY_INIT			_IO('c', 204)
> +/* generate a secret key */
> +#define NCRIO_KEY_GENERATE     	_IOWR('c', 205, struct ncr_key_generate)
> +/* generate a public key pair */
> +#define NCRIO_KEY_GENERATE_PAIR _IOWR('c', 206, struct ncr_key_generate_pair)
> +/* derive a new key from an old one */
> +#define NCRIO_KEY_DERIVE        _IOWR('c', 207, struct ncr_key_derive)
> +/* return information on a key */
> +#define NCRIO_KEY_GET_INFO      _IOWR('c', 208, struct ncr_key_get_info)
> +/* export a secret key */
> +#define NCRIO_KEY_EXPORT       	_IOWR('c', 209, struct ncr_key_export)
> +/* import a secret key */
> +#define NCRIO_KEY_IMPORT       	_IOWR('c', 210, struct ncr_key_import)
> +
> +#define NCRIO_KEY_DEINIT       _IOR ('c', 215, ncr_key_t)


Please add (another) 'c' entry to Documentation/ioctl/ioctl-number.txt.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
