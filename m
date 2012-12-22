Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab2LVXzL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 18:55:11 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33394 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752298Ab2LVXzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 18:55:07 -0500
X-Sasl-enc: HqryFAzLCW+qwYOCKGr5kLXJ4goQzU5Ci+/wkEOqfwm5 1356220506
Date: Sat, 22 Dec 2012 21:55:04 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH 08/25] thinkpad_acpi: don't use [delayed_]work_pending()
Message-ID: <20121222235504.GA12747@khazad-dum.debian.net>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-9-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356141435-17340-9-git-send-email-tj@kernel.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2012, Tejun Heo wrote:
> There's no need to test whether a (delayed) work item in pending
> before queueing, flushing or cancelling it.  Most uses are unnecessary
> and quite a few of them are buggy.
> 
> Remove unnecessary pending tests from thinkpad_acpi.  Only compile
> tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
> Cc: ibm-acpi-devel@lists.sourceforge.net
> Cc: platform-driver-x86@vger.kernel.org

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

> ---
> Please let me know how this patch should be routed.  I can take it
> through the workqueue tree if necessary.

It will not clash with anything I know of, so feel free to route it
through the workqueue tree.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
