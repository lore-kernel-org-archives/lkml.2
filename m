Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726Ab1GODan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 23:30:43 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:37775 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932589Ab1GODak convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 23:30:40 -0400
MIME-Version: 1.0
In-Reply-To: <20110715032503.GH32716@opensource.wolfsonmicro.com>
References: <20110709044923.GB13074@opensource.wolfsonmicro.com>
 <1310187044-13269-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110715025326.GH2927@ponder.secretlab.ca> <20110715032503.GH32716@opensource.wolfsonmicro.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 14 Jul 2011 21:30:19 -0600
X-Google-Sender-Auth: lNRZtBZShgalFfXdkmED6Sj-lvo
Message-ID: <CACxGe6vHQz-drkEHHGkoBz+-egLUP0gQpP-7G8H6JvaEQQTUKA@mail.gmail.com>
Subject: Re: [PATCH 1/4] regmap: Add generic non-memory mapped register access API
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg KH <greg@kroah.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 9:25 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Jul 14, 2011 at 08:53:26PM -0600, Grant Likely wrote:
>> > +err:
>> > +   return ERR_PTR(ret);
>
>> Personal soapbox: I'm not at all a fan of the ERR_PTR() pattern
>> because it provides no clues to the caller (gcc) if a failure is
>> returned as a NULL or as a 0.  Unless there is a really strong
>> argument for needing to differentiate between "no data" and "things
>> went bad", I'd rather see APIs that return NULL on failure.
>
> We should just switch to C++ and use exceptions :)

heeheehee.

g.
