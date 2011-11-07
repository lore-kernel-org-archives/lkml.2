Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757Ab1KGRSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 12:18:50 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:47985 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119Ab1KGRSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 12:18:49 -0500
Date: Mon, 7 Nov 2011 17:18:45 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Lars =?iso-8859-1?Q?Nood=E9n?= <lars.nooden@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, guenter.roeck@ericsson.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: Hardware running hot and without the fan
Message-ID: <20111107171845.GB23257@srcf.ucam.org>
References: <4EB1108F.6070009@gmail.com>
 <20111103020301.GA22333@ericsson.com>
 <4EB250FD.3070000@gmail.com>
 <20111103134902.GA26121@ericsson.com>
 <4EB2A46B.8080600@gmail.com>
 <1320332801.2309.60.camel@groeck-laptop>
 <4EB2B0FD.309@gmail.com>
 <20111103174635.GA12229@polaris.bitmath.org>
 <4EB3BE15.3070009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4EB3BE15.3070009@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 12:27:33PM +0200, Lars Noodén wrote:

> I think there are two problems.  One is the GPU or some other part
> running hot.  The other is the sensors/fans issue: the fans don't turn
> on even when the system is hot.  Both problems are evident on two
> different models of hardware, the notebook is a MacBookPro8,2 and the
> desktop is a Macmini3,1.

Fan control is under the control of the SMC. If fans aren't working then 
either we're supposed to be feeding data into the SMC or there's a 
hardware problem of some description.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
