Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab0KNMhl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 07:37:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:44087 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab0KNMhl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 07:37:41 -0500
Subject: Re: [PATCH] sata-via: enable magic transmission fix for vt6420
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Joseph Chan <JosephChan@via.com.tw>
In-Reply-To: <1289737911.24491.7.camel@twins>
References: <1289737911.24491.7.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 14 Nov 2010 13:37:08 +0100
Message-ID: <1289738228.24491.8.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-14 at 13:31 +0100, Peter Zijlstra wrote:
> hardware with the 2G WD drives. Adding the controller ID to this fix

Clearly that was meant to say 2T drives :-)
