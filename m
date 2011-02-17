Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab1BQPCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:02:31 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64725 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078Ab1BQPCV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:02:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=WYqBmoeRJ2PIluBj0zQbt863/LZurZVvkVS6bPtSZbJj9OnoXnkwk/gBJE0hc8YZXt
         xlp4jtzlrBxZrY4Pdy9o8Mbn+HQL5OXi0AI9GDy+YdFsTx74N2QqtSxpcFOt1X1NL3ls
         /oqoEYRMrfziqSOSyBZmlZOB1nOAwzIRwkMOA=
MIME-Version: 1.0
In-Reply-To: <20110217111619.GR19830@htj.dyndns.org>
References: <20110217111511.GQ19830@htj.dyndns.org> <20110217111619.GR19830@htj.dyndns.org>
From: Mike Snitzer <snitzer@gmail.com>
Date: Thu, 17 Feb 2011 10:01:51 -0500
Message-ID: <AANLkTi=rPKN25yZTziv1dz=Ke0db8ZOwUgKFNzWn9+x7@mail.gmail.com>
Subject: Re: [PATCH v2.6.38-rc5 2/2] block: blk-flush shouldn't call directly
 into q->request_fn() __blk_run_queue()
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jan Beulich <JBeulich@novell.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Thu, Feb 17, 2011 at 6:16 AM, Tejun Heo <tj@kernel.org> wrote:

> Jens, this is applicable to v2.6.37 and 38.  The new implementation
> for 39 would need similar fix but I couldn't find where the tree is.
> Which branch is it?

for-2.6.39/core
