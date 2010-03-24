Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab0CXNRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 09:17:05 -0400
Received: from poutre.nerim.net ([62.4.16.124]:57337 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756186Ab0CXNRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 09:17:03 -0400
Date: Wed, 24 Mar 2010 14:16:58 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Jean-Michel Hautbois <jhautbois@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]I2C device - release cleanup
Message-ID: <20100324141658.382209c3@hyperion.delvare>
In-Reply-To: <0016e6d977228ec35704827c94c6@google.com>
References: <20100323172143.6b078b2e@hyperion.delvare>
	<0016e6d977228ec35704827c94c6@google.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Mar 2010 19:11:26 +0000, jhautbois@gmail.com wrote:
> > Yes, that would be better. If you do that, please make sure to run your
> 
> > patch through scripts/checkpatch.pl before sending it.
> 
> I will take the time to do it. I can't say when :p.
> I did run checkpatch.pl, and I can't remove the 3 "trailing whitespace"  
> errors...

You'll have to, otherwise I won't apply your patches (nobody will).

> Plus the fact that gmail is changing tabs and spaces...

Check the options. At least attaching the patch should work. Or you can
use a "real" e-mail client for sending patches.

-- 
Jean Delvare
