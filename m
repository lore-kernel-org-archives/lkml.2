Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968244Ab2ESAsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 20:48:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21579 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab2ESAsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 20:48:10 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=PpG1Yf0aK_AA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=NI2ixf9N0mC-Z7p8rEUA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337388488.7562.13.camel@gandalf.stny.rr.com>
Subject: Re: [ 00/53] 3.2.18-stable review
From: Steven Rostedt <rostedt@goodmis.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Date: Fri, 18 May 2012 20:48:08 -0400
In-Reply-To: <1337378456.4107.101.camel@deadeye>
References: <20120518023254.339945758@decadent.org.uk>
	 <20120518144657.GA18264@home.goodmis.org>
	 <20120518182256.GC31313@kroah.com> <1337378456.4107.101.camel@deadeye>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 23:00 +0100, Ben Hutchings wrote:

> Seems like it might be easier for everyone if I would just send the rc1
> combined patch in email.  Anyway, here it is as an attachment.

You should also state that this is an incremental patch from 3.2.17 and
not a full stable patch from 3.2. The name didn't express that.

-- Steve


