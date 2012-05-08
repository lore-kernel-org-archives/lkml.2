Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab2EHP3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:29:06 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34856 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618Ab2EHP3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:29:05 -0400
Date: Tue, 8 May 2012 16:31:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Lameter <cl@linux.com>
Cc: Robert =?UTF-8?B?xZp3acSZY2tp?= <robert@swiecki.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: mmap/clone returns ENOMEM with lots of free memory
Message-ID: <20120508163144.13ab1814@pyramind.ukuu.org.uk>
In-Reply-To: <alpine.DEB.2.00.1205080859570.25669@router.home>
References: <CAP145pjtv-S2oHhn8_QfLKF8APtut4B9qPXK5QM8nQbxzPd2gw@mail.gmail.com>
	<alpine.DEB.2.00.1205071514040.6029@router.home>
	<CAP145piK2kW4F94pNdKpo_sGg8OD914exOtwCx2o+83jx5Toog@mail.gmail.com>
	<alpine.DEB.2.00.1205080859570.25669@router.home>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Setting overcommit memory to 2 means that the app is strictly policed
> for staying within bounds on virtual memory. Dont do that.

For a fuzz test you probably do want it at 2 to avoid the box dying in a
swap storm.


Alan
