Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab0KOJev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 04:34:51 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65251 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab0KOJeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 04:34:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ncXgp09XaK8a8ttPDYgwdSacYdqAYS0Rvll9qbgtn7/98s9sWeEMI9p2KB/LPERM4s
         0Y04Ygi+EGIBSc4WV1A6c696hHVd9V+n/pPufbeO/cc4tZb+8BDisXugIWI0dJFv+4J5
         O60iXjS1TqLo63VBKfQ/OaYyK26qpl+XOJoNE=
Date: Mon, 15 Nov 2010 10:34:46 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC 0/8] Dynamic clock devices
Message-ID: <20101115093446.GA15936@riccoc20.at.omicron.at>
References: <cover.1288897198.git.richard.cochran@omicron.at>
 <1289257264.2798.98.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289257264.2798.98.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 03:01:04PM -0800, john stultz wrote:
> That said, given how different this is from the last implementation, I'm
> not fully clear I see how to integrate this into my patch set. It might
> be useful to see a trivial example of how you see a clockdevice being
> registered and used.

Okay, I will post again, with the PTP code as user of the new layer.

Thanks,
Richard
