Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760770Ab2FVAab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 20:30:31 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:52039 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760711Ab2FVAaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 20:30:30 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-02-4fe3bca46280
Message-id: <4FE3BCA3.2040907@samsung.com>
Date: Fri, 22 Jun 2012 09:30:27 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: gregkh@linuxfoundation.org, thomas.abraham@linaro.org,
        grant.likely@secretlab.ca, sameo@linux.intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: add irq domain support for max8997 interrupts
References: <1340241040-22257-1-git-send-email-cw00.choi@samsung.com>
 <20120621095420.GO4037@opensource.wolfsonmicro.com>
In-reply-to: <20120621095420.GO4037@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t9jQd0lex77G6xq5LS4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZtz7cZy94zFJx8dR8xgbGv8xdjJwcEgImEs8uvGeBsMUkLtxb
	zwZiCwlMZ5R4dUipi5ELyO5mkli5eAkrSIJXQEti7Z9ZQM0cHCwCqhJHV/mBhNmAwvtf3GAD
	CYsKREj86ueAqBaU+DH5HgtIWARo1e/7lSATmQUOMUpM/L+XHaRGWMBb4subSawQa6slLvXc
	YwKxOQUcJJomzwA7k1lAR2J/6zQ2CFteYvOat8wTGAVmIVkxC0nZLCRlCxiZVzGKphYkFxQn
	peca6RUn5haX5qXrJefnbmIEB98z6R2MqxosDjEKcDAq8fBe2PDYX4g1say4MhfoSg5mJRHe
	H4lAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rxN1hf8hQTSE0tSs1NTC1KLYLJMHJxSDYy8Jj9z
	a3KEZRb5TrfZeitCelHxshtXo2erpkivOcUa4KMRaej8YfYPr5g1IkFGxl5peiEvrN//n95v
	6dpwqnhZuazrBKYTf5qOr3yYei5R7mYSe2PhQ743k4Vqpx76tPj72pysw/pyCwNEtojJd9vO
	aTixbfu3roYjbCazzzhftbhv/aNS9IMSS3FGoqEWc1FxIgBfbyA8OgIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2012 06:54 PM, Mark Brown wrote:

> On Thu, Jun 21, 2012 at 10:10:40AM +0900, Chanwoo Choi wrote:
> 
>> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> Small procedural thing: it's not Signed-off-by as I didn't write or
> forward the patch, I'll have sent a Reviwed-by or something.


This patch based on below patch was modified, I should remove your
Signed-off-by.
I will resend it without your Signed-off-by. Sorry.

http://git.kernel.org/?p=linux/kernel/git/broonie/regulator.git;a=commit;h=98d8618af37728f6e18e84110ddb99987b47dd12

Thank you,
Chanwoo Choi

