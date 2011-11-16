Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab1KPIrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 03:47:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37964 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132Ab1KPIrI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 03:47:08 -0500
Subject: Re: [PATCH] lockdep: Don't disable lockdep for out of tree modules
From: Peter Zijlstra <peterz@infradead.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 16 Nov 2011 09:46:43 +0100
In-Reply-To: <1321429835-1466-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1321429835-1466-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1321433203.1421.69.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 13:20 +0530, Aneesh Kumar K.V wrote:
> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> 
> I guess it would be nice to get lockdep enabled for out of tree GPL modules

How about you get them in staging instead?
