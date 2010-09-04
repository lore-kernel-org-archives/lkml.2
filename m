Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab0IDRz0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 13:55:26 -0400
Received: from smtprelay03.ispgateway.de ([80.67.29.7]:38022 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab0IDRzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 13:55:25 -0400
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Sat, 04 Sep 2010 13:55:25 EDT
Message-ID: <4C828652.4060804@gmail.com>
Date: Sat, 04 Sep 2010 19:48:02 +0200
From: Christian Riesch <christian.riesch@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH 0/2] [RFC] posix clock tuning
References: <cover.1283504065.git.richard.cochran@omicron.at> <alpine.DEB.2.00.1009041221240.888@router.home>
In-Reply-To: <alpine.DEB.2.00.1009041221240.888@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Df-Sender: christian@riesch.at
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Fri, 3 Sep 2010, Richard Cochran wrote:
>> Recently on the lkml, we discussed how to allow adjustment of posix
>> clocks. I have tried to understand and implement the ideas expressed
>> in the various threads.
....
> Could you explain why the existing interfaces are not sufficient that do
> what you describe?

Richard's idea is to support clock hardware for IEEE 1588 (PTP, 
Precision Time Protocol). Have a look at the earlier discussions:

http://lkml.org/lkml/2010/8/16/90
and
http://lkml.org/lkml/2010/8/23/49

Christian
