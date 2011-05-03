Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab1ECA0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 20:26:48 -0400
Received: from mail.perches.com ([173.55.12.10]:1153 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231Ab1ECA0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 20:26:47 -0400
Subject: Re: [PATCH] drivers/acpi/utils.c: Fixed coding style issues
From: Joe Perches <joe@perches.com>
To: Karthigan Srinivasan <karthigan.srinivasan@hp.com>
Cc: Len Brown <lenb@kernel.org>, Nicolas Kaiser <nikai@nikai.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1304374605.1619.4.camel@ks-ubuntu>
References: <1303341624.11397.2.camel@ks-ubuntu>
	 <20110421102815.5abf133e@absol.kitzblitz>
	 <1303402099.11855.9.camel@ks-ubuntu>  <1304374605.1619.4.camel@ks-ubuntu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 May 2011 17:26:45 -0700
Message-ID: <1304382405.7792.53.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-02 at 17:16 -0500, Karthigan Srinivasan wrote:
>  drivers/acpi/utils.c |   15 ++++++---------
> @@ -373,7 +370,7 @@ acpi_evaluate_reference(acpi_handle handle,
>        end:
>  	if (ACPI_FAILURE(status)) {
>  		list->count = 0;
> -		//kfree(list->handles);
> +		/* kfree(list->handles); */

Just delete the line instead.


