Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577Ab2CNIdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 04:33:42 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55912 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932343Ab2CNIdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 04:33:38 -0400
Message-ID: <1331714014.8688.3.camel@dabdike>
Subject: Re: [PATCH] mpt2sas: Corrected the constant in comparison to a
 hexadecimal.
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Sathisha Nanjappa <sathisha.nanjappa@hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 14 Mar 2012 08:33:34 +0000
In-Reply-To: <1331665168-22561-2-git-send-email-sathisha.nanjappa@hp.com>
References: <1331665168-22561-1-git-send-email-sathisha.nanjappa@hp.com>
	 <1331665168-22561-2-git-send-email-sathisha.nanjappa@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-13 at 11:59 -0700, Sathisha Nanjappa wrote:
> Bugzilla 42142 - mpt2sas: Number specified in wrong base
>     https://bugzilla.kernel.org/show_bug.cgi?id=42142

Do you have a better description ... like what is the user visible
effect of correcting the constant?

James


