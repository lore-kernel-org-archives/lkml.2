Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab1BIVDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 16:03:54 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42821 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752671Ab1BIVDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 16:03:53 -0500
Date: Wed, 9 Feb 2011 21:07:19 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Niranjana Vishwanathapura <nvishwan@codeaurora.org>
Cc: alan@linux.intel.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        swetland@google.com, dima@android.com
Subject: Re: [PATCH v2] tty: Add msm_smd_tty driver
Message-ID: <20110209210719.185834c1@lxorguk.ukuu.org.uk>
In-Reply-To: <1297278994-22155-1-git-send-email-nvishwan@codeaurora.org>
References: <1297278994-22155-1-git-send-email-nvishwan@codeaurora.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 Feb 2011 11:16:34 -0800
Niranjana Vishwanathapura <nvishwan@codeaurora.org> wrote:

> msm_smd_tty driver provides tty device interface
> to 'DS' and 'GPSNMEA' streaming SMD ports.
> 
> Cc: Brian Swetland <swetland@google.com>
> Signed-off-by: Niranjana Vishwanathapura <nvishwan@codeaurora.org>

Acked-by: Alan Cox <alan@linux.intel.com>

Thanks for reworking it for the current refcount/port stuff

Alan
