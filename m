Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab0DNMqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 08:46:23 -0400
Received: from ns2.intersolute.de ([193.110.43.67]:46757 "EHLO
	ns2.intersolute.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab0DNMqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 08:46:22 -0400
Message-ID: <4BC5B915.6090803@lumino.de>
Date: Wed, 14 Apr 2010 14:46:13 +0200
From: Michael Schnell <mschnell@lumino.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-2.3 Thunderbird/3.0.4
MIME-Version: 1.0
To: nios2-dev <nios2-dev@sopc.et.ntust.edu.tw>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: atomic RAM ?
References: <4BBD86A5.5030109@lumino.de>	<20100408114542.47b6589a@lxorguk.ukuu.org.uk>	<4BBDC7D4.6040301@lumino.de> <20100408143750.0acebaa1@lxorguk.ukuu.org.uk>
In-Reply-To: <20100408143750.0acebaa1@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2010 03:37 PM, Alan Cox wrote:
> FUTEX  ... is an implementation ...  for certain classes of processor.

Alan,

If that is true "in depth", there should be no FUTEX-relevant  code,
neither in the Kernel, nor in the library, that should be considered
"arch-independent".

If so, we could happily create a "atomic hardware RAM" - based (or
whatever type of) FUTEX for the arch in question in the arch's source
files, without needing to take care of what happens in the rest of the
Kernel or Library code.

Provided this implementing the idea I presented might be a doable task.

-Michael
