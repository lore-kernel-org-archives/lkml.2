Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab0H3RAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:00:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:45664 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756008Ab0H3RAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:00:38 -0400
Message-ID: <4C7BE3AE.8020204@suse.de>
Date: Mon, 30 Aug 2010 22:30:30 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Miguel Calleja <mcalleja1@telecable.es>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-cifs@vger.kernel.org,
        Shirish S Pargaonkar <shirishp@us.ibm.com>
Subject: Re: Linux 2.6.36-rc3
References: <AANLkTinRRiW1VUzS+3T82=q8PsoRn78Cgn_X8gSduM0U@mail.gmail.com> <i5fr6h$ih6$1@dough.gmane.org>
In-Reply-To: <i5fr6h$ih6$1@dough.gmane.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Cc linux-cifs@vger.kernel.org)

Couldn't get a chance to check this, but I guess this is perhaps due to
the recent crypto patches..

On 08/30/2010 02:17 PM, Miguel Calleja wrote:
> CIFS does not build without CRYPTO selected.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Suresh Jayaraman
