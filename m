Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab2IJHcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 03:32:48 -0400
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40323 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751004Ab2IJHco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 03:32:44 -0400
Date: Mon, 10 Sep 2012 10:32:38 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Prabhakar Lad <prabhakar.lad@ti.com>
Cc: LMML <linux-media@vger.kernel.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        linux-kernel@vger.kernel.org, Manjunath Hadli <manjunath.hadli@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-doc@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Landley <rob@landley.net>
Subject: Re: [PATCH v5] media: v4l2-ctrls: add control for dpcm predictor
Message-ID: <20120910073238.GH6834@valkosipuli.retiisi.org.uk>
References: <1347256675-13391-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347256675-13391-1-git-send-email-prabhakar.lad@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

On Mon, Sep 10, 2012 at 11:27:55AM +0530, Prabhakar Lad wrote:
...
> +	  <row id="v4l2-dpcm-predictor">
> +	    <entry spanname="descr"> Differential pulse-code modulation (DPCM) compression can
> +	    be used to compress the samples into fewer bits than they would otherwise require.
> +	    This is done by calculating the difference between consecutive samples and outputting
> +	    the difference which in average is much smaller than the values of the samples
> +	    themselves since there is generally lots of correlation between adjacent pixels. In
> +	    decompression the original samples are reconstructed. The process isn't lossless as
> +	    the encoded sample size in bits is less than the original.
> +
> +	    <para>Formats using DPCM compression include <xref linkend="pixfmt-srggb10dpcm8" />.</para>
> +
> +	    <para>This control is used to select the predictor used to encode the samples.</para>
> +
> +	    <para>The main difference between the simple and the advanced predictors is image quality,
> +	    with advanced predictor supposed to produce better quality images as a result. Simple
> +	    predictor can be used e.g. for testing purposes. For more information about DPCM see <ulink
> +	    url="http://en.wikipedia.org/wiki/Differential_pulse-code_modulation">Wikipedia</ulink>.</para>

Could you fit the above text (description of the control) at 80 characters
per line? With that change,

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
