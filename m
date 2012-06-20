Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab2FTKOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:14:09 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58007 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab2FTKOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:14:07 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: mkl@pengutronix.de, bhupesh.sharma@st.com, sfr@canb.auug.org.au,
        netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        wg@grandegger.com
Subject: Re: linux-next: build failure after merge of the net-next tree
Date: Wed, 20 Jun 2012 12:17:36 +0200
Message-ID: <1634770.3jzQipHk0k@harkonnen>
User-Agent: KMail/4.8.3 (Linux/3.4.2-4.fc17.x86_64; KDE/4.8.3; x86_64; ; )
In-Reply-To: <20120620.025837.721158723130014230.davem@davemloft.net>
References: <3170667.1PZa2330KE@harkonnen> <5059693.iaLYtpk3E4@harkonnen> <20120620.025837.721158723130014230.davem@davemloft.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why would you try to be generic by using an interface currently
> only available on certain platforms?

I know, I was wrong.

> That is how you make drivers non-portable, and not generic.

Now is fixed in my mind; I learn the lesson.

-- 
Federico Vaga
