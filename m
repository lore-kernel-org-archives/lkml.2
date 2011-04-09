Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab1DIJlg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 05:41:36 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:56690 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab1DIJlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 05:41:35 -0400
Date: Sat, 9 Apr 2011 10:41:34 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Michael Guntsche <mike@it-loops.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.39-rc[12]] hangs during boot
Message-ID: <20110409094134.GA12807@sucs.org>
References: <20110408052921.GA17375@gibson.comsick.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110408052921.GA17375@gibson.comsick.at>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 08, 2011 at 07:29:21AM +0200, Michael Guntsche wrote:
> 
> On a side note since I read similar reports already. This is a happening
> with a CONFIG_NO_HZ/TICK_ONESHOT non-PREEMPT kernel.

Does the problem go away with a PREEMPT kernel?

-- 
Sitsofe | http://sucs.org/~sits/
