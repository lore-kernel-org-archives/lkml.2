Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab0EJOFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 10:05:32 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47511 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab0EJOFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 10:05:31 -0400
Date: Mon, 10 May 2010 15:05:28 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Deepak Sikri <deepak.sikri79@gmail.com>
Cc: linux-pm@lists.linux-foundation.org, viresh.kumar@st.com,
       rajeev-dlh.kumar@st.com, armando.visconti@st.com,
       linux-kernel@vger.kernel.org, vipin.kumar@st.com, shiraz.hashim@st.com
Subject: Re: [linux-pm]  Power Domain Framework
Message-ID: <20100510140527.GG5199@sirena.org.uk>
References: <AANLkTinZU1D1rMOBQDi47tRhXrOXwduQIdni7bCXdce0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinZU1D1rMOBQDi47tRhXrOXwduQIdni7bCXdce0@mail.gmail.com>
X-Cookie: Danger: do not shake.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 07:16:06PM +0530, Deepak Sikri wrote:

> In our System on chip we have several power domains. As such there is no
> generic framework for the Power Domains in linux , and I find huge potential
> in the software to control the domains and exploit the power management
> capabilities.

> There is one very small model that I could think of, something on the lines
> of clock framework.

Might be worth looking at what the OMAP and SH Mobile CPUs are doing
here, they have existing handling for power domains.  Off-SoC the
regulator API should already cope with a lot of this stuff.
