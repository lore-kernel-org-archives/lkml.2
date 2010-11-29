Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab0K2KLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 05:11:40 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51826 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab0K2KLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 05:11:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=vlTFMFPyw1gF38A5ihsO+Bc7ZvB/ANYY60t6cWAiC1B2ABdF6yu+hIhwl5j2ky+Rb2
         FHOGNgTCOe1tdVdiIq6blnHwKSM8EJGFmTRBTgOPRlLmUhl9k+04nvZFjTnZy854R4dx
         42UuYfBl9Zm4os3RkMy/o5K336X1khZBmkDIY=
Subject: Re: VT console need rewrite
From: Microcai <microcai@fedoraproject.org>
Reply-To: microcai@fedoraproject.org
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
In-Reply-To: <87mxosla7p.fsf@basil.nowhere.org>
References: <1290941875.13526.15.camel@cai.gentoo>
	 <87mxosla7p.fsf@basil.nowhere.org>
Content-Type: text/plain; charset="UTF-8"
Organization: fedoraproject.org
Date: Mon, 29 Nov 2010 18:12:57 +0800
Message-ID: <1291025577.9785.7.camel@cai.gentoo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2010-11-29一的 11:01 +0100，Andi Kleen写道：

> To be honest I have doubts its worth it. This was discussed years and
> years ago and the conclusion back then that people who need unicode
> fonts should use them in X or another graphical console environment
> (there are plenty to chose from these days). Has this changed?
> 
> -Andi
> 

Yes, it change. Linux graphical stuck have changed a lot. With KMS,
console got a native resolution, and looks very nice.



