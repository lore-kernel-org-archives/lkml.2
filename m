Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab1BVJpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 04:45:44 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34924 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab1BVJpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 04:45:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LAXvppiNpiFjwYjHc5jBYGYDVCJ7MmDCyqYmsBY8nCaaGeiRDUBm2x0KgYKf0Xhl4L
         QfLsM974V4aPETLPHJGZccUJ10uZj9smGWdrSRx95jv10cGSOWByy4vILXqKi5hQDLjf
         F2UTde+0f12dEShkJn6BXNfIMHQuHISz6BDpU=
Date: Tue, 22 Feb 2011 12:45:37 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Pali Rohar <pali.rohar@gmail.com>, Rodolfo Giometti <giometti@linux.it>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/16] bq27x00: New Properties, fixes, bq27000
 support
Message-ID: <20110222094537.GA9709@oksana.dev.rtsoft.ru>
References: <1298356681-8317-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1298356681-8317-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The patches look great!

On Tue, Feb 22, 2011 at 07:37:45AM +0100, Lars-Peter Clausen wrote:
[...]
> Lars-Peter Clausen (11):
>   power_supply: Ignore -ENODATA errors when generating uevents
>   power_suply: Initialize changed_work before calling device_add

Just a nit. There is a typo: suply should be supply.

No need to resend the patches, could you please just fix it
in your tree?

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
