Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab0K3GJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 01:09:35 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50020 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab0K3GJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 01:09:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mAK2CVqrkMQFtHcGJuV6G/PFc/POGCAzLVL7nIiv3ED+RvkBVflK4QzYg4b/F3rqL1
         1s4FzBHp9WVlIZPWr4rgy/rCVlwf3y2lDJLOGkD31swiHlgBD7kZQu26OSQOLFln78VF
         I8lHDgsPeVPjQUPQljBMxdL3/lrGyV5YmhWLQ=
Date: Mon, 29 Nov 2010 22:09:26 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: mems applications <mems.applications@st.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        matteo.dameno@st.com, carmine.iascone@st.com,
        mems <mems@mems-laptopT43.corenet.prv>
Subject: Re: [PATCH] input: misc: add lps001wp_prs driver
Message-ID: <20101130060926.GA31838@core.coreip.homeip.net>
References: <matteo.dameno@st.com>
 <1291049009-32597-1-git-send-email-matteo.dameno@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291049009-32597-1-git-send-email-matteo.dameno@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Nov 29, 2010 at 05:43:29PM +0100, mems applications wrote:
> +config INPUT_LPS001WP_PRS
> +	tristate "STMicro LPS001WP Pressure Temperature Sensor"
> +	depends on I2C
> +	default n
> +	help
> +	 If you say yes here you get support for the 
> +	 STM LPS001D Barometer/Termometer on I2C bus.

This does not belong to input subsystem, IIO is a better fit.

Thanks.

-- 
Dmitry
