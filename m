Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab2G3RQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 13:16:46 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:46891 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab2G3RQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 13:16:44 -0400
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=message-id:from;
	b=gzFkd+xMOAUnmss1Sm8kEw1h+2P7R1tD4oyxv1PftgkFZH+ut6klMhjM4Tju
	ls6oP6S6shnw5zaLojkULnTxvW/tQOkD778jhHu559u64eRmSvERpx9U1
	Yw7WWbEjG7CzKzUD8LHbQjqchSFgwL9OeoVm1s+rs8CLIpZDdIRccE=;
X-Spam-Processed: mail.digidescorp.com, Mon, 30 Jul 2012 12:16:42 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1558eb3138=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <1343668599.2153.12.camel@iscandar.digidescorp.com>
Subject: Re: Alternative to vfork(2) with overcommit off
From: "Steven J. Magnani" <steve@digidescorp.com>
To: Shea Levy <shea@shealevy.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 30 Jul 2012 12:16:39 -0500
In-Reply-To: <EC19EF84-3DD4-4B5A-9469-2EC11EE089D6@shealevy.com>
References: <EC19EF84-3DD4-4B5A-9469-2EC11EE089D6@shealevy.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-30 at 12:59 -0400, Shea Levy wrote: 
> Hello,
> 
> The vfork(2) manpage states "It is rather unfortunate that Linux revived this specter from the past", but on systems with overcommit turned off fork(2) can be needlessly prohibitive when the goal is to execve(2) right away. Is there a third alternative for the fork/execve case? If not, should the manpage really be so dismissive of vfork?

On noMMU (embedded) systems, fork() is not implementable and vfork() is
the only option.
Not everyone can afford a Lexus.

------------------------------------------------------------------------
Steven J. Magnani               "I claim this network for MARS!
www.digidescorp.com              Earthling, return my space modulator!"

#include <standard.disclaimer>



