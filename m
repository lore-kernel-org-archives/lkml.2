Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab1DSGn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 02:43:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61257 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab1DSGn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 02:43:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vYvwms93ADQhLdaQaSmZG4iar5QAVOwIGdbS+J1gbIuRgoO5itqrH0Ls91hllep5ML
         rT5eW+z5v/kBI+jOJjM8yL5lqq90QN/xx3XqJ/2ynXCFrWAECfpkQlSwfIA2Nj+XkfXE
         7FJUXF7YogRHnXTAHeAk4jjICBLKKnK6iT8B4=
Date: Tue, 19 Apr 2011 01:41:14 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-s390@vger.kernel.org, Stephen Powell <zlinuxman@wowway.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [OOPS s390] Unable to handle kernel pointer dereference at
 virtual kernel address (null)
Message-ID: <20110419064114.GA28291@elie>
References: <2099315211.286690.1302917498637.JavaMail.root@md01.wow.synacor.com>
 <20110416014811.GA6150@elie>
 <20110419063400.GA2878@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110419063400.GA2878@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:

> Ok, I was able to reproduce it and could verify that my patch fixes the bug.

Thanks!

> Cc: Jonathan Nieder <jrnieder@gmail.com>

The patch makes sense to me fwiw.
