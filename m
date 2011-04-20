Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab1DTJqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 05:46:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54001 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752012Ab1DTJqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 05:46:06 -0400
Date: Wed, 20 Apr 2011 10:46:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Rientjes <rientjes@google.com>
Cc: james_p_freyensee@linux.intel.com, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
Subject: Re: [PATCH 3/4] Intel PTI implementaiton of MIPI 1149.7.
Message-ID: <20110420104654.6b457142@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.DEB.2.00.1104191822440.8047@chino.kir.corp.google.com>
References: <james_p_freyensee@linux.intel.com>
	<1303253889-10074-4-git-send-email-james_p_freyensee@linux.intel.com>
	<alpine.DEB.2.00.1104191822440.8047@chino.kir.corp.google.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> is small enough that it shouldn't be an issue.  Otherwise there's nothing 
> protecting sizeof(current->comm) from changing without holding 
> task_lock(current).

The C language definition for one - sizeof() is a constant at compile time
