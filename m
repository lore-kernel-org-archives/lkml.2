Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab0HIV3H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 17:29:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:54948 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623Ab0HIV3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 17:29:06 -0400
Subject: Re: Query: Patches break with Microsoft exchange server.
From: David Woodhouse <dwmw2@infradead.org>
To: Mihai =?UTF-8?Q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
        viresh kumar <viresh.kumar@st.com>,
        Matti Aarnio <matti.aarnio@zmailer.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <201008092115.25992.mihai.dontu@gmail.com>
References: <4C5F9B25.8080401@st.com>
	 <201008091735.11105.mihai.dontu@gmail.com> <4C6040FC.2020702@gmail.com>
	 <201008092115.25992.mihai.dontu@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Aug 2010 22:28:58 +0100
Message-ID: <1281389338.7143.32.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.6 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-09 at 21:15 +0300, Mihai Donțu wrote:
> 
> Wait. I don't think we're on the same page here. I'm talking about message 
> signing (which does not require the receiving end to have any key - it's the 
> same plain text e-mail with a blob after it) while you refer to actually 
> encrypting the message. Mm? Or am I being extremely slow today? :-) 

Only when you assume that Exchange would pass signed messages without
corrupting them. It really is that broken.

-- 
dwmw2

