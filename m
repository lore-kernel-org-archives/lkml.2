Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab2A3K5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 05:57:45 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46852 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab2A3K5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 05:57:44 -0500
Date: Mon, 30 Jan 2012 10:59:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "R, Durgadoss" <durgadoss.r@intel.com>
Cc: "mjg@redhat.com" <mjg@redhat.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] platform-x86: intel_mid_thermal: add msic_thermal
 alias
Message-ID: <20120130105905.34e44578@pyramind.ukuu.org.uk>
In-Reply-To: <4D68720C2E767A4AA6A8796D42C8EB5902FDDD@BGSMSX101.gar.corp.intel.com>
References: <20120126173729.16719.15431.stgit@bob.linux.org.uk>
	<20120126173912.16719.51752.stgit@bob.linux.org.uk>
	<4D68720C2E767A4AA6A8796D42C8EB5902FDDD@BGSMSX101.gar.corp.intel.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In all the medfield boards, that we use here, this is named 'msic_thermal'.
> So, maybe we should remove msic_sensor and just use msic_thermal.
> Or, Do you have any medfield boards that have this entry as 'msic_sensor' ?

I will check if we do.

Alan
