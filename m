Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab1AVN7A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 08:59:00 -0500
Received: from canuck.infradead.org ([134.117.69.58]:40635 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab1AVN67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 08:58:59 -0500
Subject: Re: [PATCH 0/7] Nexus One Support
From: David Woodhouse <dwmw2@infradead.org>
To: Dima Zavin <dmitriyz@google.com>
Cc: Daniel Walker <dwalker@codeaurora.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Joe Perches <joe@perches.com>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, davidb@codeaurora.org
In-Reply-To: <AANLkTinrGUMBqh657Y2fFCUWKDFwYsGZKb73O_iO9wzm@mail.gmail.com>
References: <1295555565-21563-1-git-send-email-dwalker@codeaurora.org>
	 <AANLkTik+HCj9dkD2s4WgwCqKWCXDbdSnKDUbyGfYfaPr@mail.gmail.com>
	 <1295571359.9236.53.camel@m0nster> <1295574085.4096.6.camel@Joe-Laptop>
	 <1295575123.9236.54.camel@m0nster> <1295576730.4096.24.camel@Joe-Laptop>
	 <1295624801.19880.13.camel@m0nster>
	 <20110121094827.41818a55@jbarnes-desktop>
	 <20110121095658.1ab623fe@jbarnes-desktop>
	 <1295632828.19880.22.camel@m0nster>
	 <20110121100441.06a94482@jbarnes-desktop>
	 <1295633882.19880.31.camel@m0nster>
	 <AANLkTi=L+MW5-KLP_TKSxhstD8JEtBW=RKci5wSbZsd6@mail.gmail.com>
	 <1295642995.19880.42.camel@m0nster>
	 <20110121130106.5f30908d@jbarnes-desktop>
	 <1295645218.22882.2.camel@m0nster>
	 <AANLkTinrGUMBqh657Y2fFCUWKDFwYsGZKb73O_iO9wzm@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 22 Jan 2011 23:58:47 +1000
Message-ID: <1295704727.7115.35.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-21 at 13:42 -0800, Dima Zavin wrote:
> My main point is that the authorship of this code is VERY easy to
> ascertain. It is not like a lot of other vendor code that gets thrown
> over the wall as a tarball. We really do our best to follow the right
> practices, give the right credits, create legible well separated
> commits, etc. 

So your code was already submitted to Linus in a form that he'll accept,
and Daniel is just completely wasting his time?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

