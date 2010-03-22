Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab0CVMap (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:30:45 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:58619 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab0CVMao convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:30:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=bEMRjv6nRotXcPxn8QCRsuhVa7vIk05bVzBNy/+WCfpm8H80ru2fYQL4/IO935AJs8
         DlGda5F8skF2SJJ1Dpayvl3kWVlV9bbavGqjA2BTQYBipuCE7XrEJZfUroNE7G7cBUKo
         FnfZFAo8hDbZuf50PG8QqYQIz0gPrpy0gIHXk=
MIME-Version: 1.0
In-Reply-To: <20100322121034.GI21571@bicker>
References: <20100322121034.GI21571@bicker>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 22 Mar 2010 20:30:22 +0800
Message-ID: <f17812d71003220530p7c45fbd4r6938433d379bc67@mail.gmail.com>
Subject: Re: [patch] pxa168fb: use resource_size()
To: Dan Carpenter <error27@gmail.com>, Jun Nie <njun@marvell.com>,
       Eric Miao <eric.y.miao@gmail.com>,
       Lennert Buytenhek <buytenh@marvell.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>, Kevin Liu <kliu5@marvell.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 8:10 PM, Dan Carpenter <error27@gmail.com> wrote:
> The size calculation is not correct.  It should be end - start + 1.
> Use resource_size() to caculate it.
>
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Applied to 'fix'.
