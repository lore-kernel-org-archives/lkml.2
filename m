Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab1CBTqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 14:46:46 -0500
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:34727 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440Ab1CBTqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 14:46:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=subject:from:to
	:cc:in-reply-to:references:content-type:date:message-id
	:mime-version:content-transfer-encoding; q=dns; s=sasl; b=O0p9iy
	eCRSjNEUdm9aidIHL+kLSmOYTmH+iRTiSxEB8/oVpshygWJ14GzyAYU73r5lhcxp
	Ns6z0RZaiGwSIwY4R9bxnZfI8OXwJPGuXeQh+XFCoFsclPw/zDLPZ0oz2XTmCk5n
	KSEr3Q7/Vi2oI8f5Hj9VOn7+f3LkwSgYAeGa4=
Subject: Re: [PATCH] bloat-o-meter: Include read-only data section in report
From: Nathan Lynch <ntl@pobox.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110302181544.2f1b3be9@endymion.delvare>
References: <20110302181544.2f1b3be9@endymion.delvare>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Mar 2011 13:46:30 -0600
Message-ID: <1299095190.27127.76.camel@tp-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: FA76BE1C-4505-11E0-BBFB-AF401E47CF6F-04752483!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-02 at 18:15 +0100, Jean Delvare wrote:
> I'm not sure why the read-only data section is excluded from the
> report, it seems as relevant as the other data sections (b and d).
> 
> I've stripped the symbols starting with __mod_ as they can have their
> names dynamically generated and thus comparison between binaries is
> not possible.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>

Seems to do the right thing here.

Acked-by: Nathan Lynch <ntl@pobox.com>


