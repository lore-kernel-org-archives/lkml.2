Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab1BBMLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 07:11:12 -0500
Received: from mx1.zhaw.ch ([160.85.104.50]:61077 "EHLO mx1.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365Ab1BBMLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 07:11:11 -0500
Date: Wed, 2 Feb 2011 13:11:08 +0100
From: Tobias Klauser <klto@zhaw.ch>
To: <nios2-dev@sopc.et.ntust.edu.tw>
Cc: thomas@wytron.com.tw, Grant Likely <grant.likely@secretlab.ca>,
        <devicetree-discuss@lists.ozlabs.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>
Subject: Re: [Nios2-dev] [PATCH v2] altera_ps2: Add devicetree support
Message-ID: <20110202131108.5e7a9449@fermion>
In-Reply-To: <4D4944AA.5040900@wytron.com.tw>
References: <20110117220415.GB17963@angua.secretlab.ca>
	<1295848693-28472-1-git-send-email-thomas@wytron.com.tw>
	<20110202043121.GF29148@angua.secretlab.ca>
	<4D4944AA.5040900@wytron.com.tw>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.2.2.120022
X-PerlMx-Spam: Gauge=X, Probability=10%, Report='
 TO_IN_SUBJECT 0.5, BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1200_1299 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, INVALID_MSGID_NO_FQDN 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __TO_NO_NAME 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS '
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Feb 2011 19:48:58 +0800 Thomas Chou <thomas@wytron.com.tw> wrote:
> On 02/02/2011 12:31 PM, Grant Likely wrote:
> >> +static const struct of_device_id altera_ps2_match[] = {
> >> +	{ .compatible = "altr,ps2-1.0", },
> >
> > I thought I had seen 'altera' instead of an abbreviation being used in
> > a previous patch.  I don't care much whether 'altr' or 'altera' is
> > used, but I'd like to know that there is consensus from the Altera
> > users so that all the drivers use the same prefix.
> >
> 
> We had discussed on nios2-dev mailing list, and decided to use 'altr' as 
> Walter suggested that it saves space.
> 
> About the documentation on dts binding, shall we have a single 
> altera.txt to describe all Altera related binding, and opencores.txt to 
> describe all OpenCores binding? Or separate file for each core in its 
> driver class?

As I will submit the device tree support for the altera_uart driver
(and the altera_jtaguart driver sometime in the future) I was asking
myself the same question. I'd vote for the altera.txt solution, as we
could use that for documenting the uart drivers, other Altera component
specific drivers and also the Nios2 arch specific parameters in the
future.

Cheers
Tobias

