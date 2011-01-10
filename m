Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab1AJVLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 16:11:13 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58512 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab1AJVLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 16:11:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pisajv4FrG+27uzM+DivFyYhDq2DTvET6mnPMSSSAVYGd/hWPF0+1pPbDvS1DguXkm
         L9M6K2f0a47KG/zWdKrOuyPS1vCTGtvcxHULheBavjr3uT7h+zDObK2TxyASJRNTTe/S
         lE3s8AVRkVz136ODNXBjVBEqm2d743B9xuMGA=
Date: Mon, 10 Jan 2011 13:11:03 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Kevin McNeely <Kevin.McNeely@cypress.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, David Brown <davidb@codeaurora.org>,
        Trilok Soni <tsoni@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Eric Miao <eric.y.miao@gmail.com>, Mike Frysinger <vapier@gentoo.org>,
        Alan Cox <alan@linux.intel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [v4 1/3] 1/3 Touchscreen: Cypress TTSP G3 Core Driver
Message-ID: <20110110211103.GA16332@core.coreip.homeip.net>
References: <kev@cypress.com>
 <1294188847-24728-1-git-send-email-kev@cypress.com>
 <20110105085942.GA23321@polaris.bitmath.org>
 <FB9C2CB29A07AB45B575A4E8D2AABC09014003B8@labamba.mis.cypress.com>
 <20110105173403.GA2146@polaris.bitmath.org>
 <FB9C2CB29A07AB45B575A4E8D2AABC0901400A3F@labamba.mis.cypress.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FB9C2CB29A07AB45B575A4E8D2AABC0901400A3F@labamba.mis.cypress.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 11:27:33AM -0800, Kevin McNeely wrote:
> Hello Henrik,
> 
> As there have been no other changes requested for the v4 (other than
> your modifications), will you merge your modification patch along with
> my  v4 SPI and v4 I2C patches?
> 
> Do I need to submit a v5 with your patch in order to get merged?
> 

Hi Kevin,

I have a few comments/changes, let me try to sort through them
tonight/tomorrow.

Thanks.

-- 
Dmitry
