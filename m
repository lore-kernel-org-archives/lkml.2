Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975Ab1KGQ0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:26:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:56528 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab1KGQ0D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:26:03 -0500
Subject: Re: [PATCHv2 6/9] perf: expose perf capability to other modules.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, acme@ghostprotocols.net
Date: Mon, 07 Nov 2011 17:25:00 +0100
In-Reply-To: <20111107162207.GK8670@redhat.com>
References: <1320323618-10375-1-git-send-email-gleb@redhat.com>
	 <1320323618-10375-7-git-send-email-gleb@redhat.com>
	 <1320674870.18053.37.camel@twins> <20111107155336.GI8670@redhat.com>
	 <1320681671.17809.5.camel@twins> <20111107162207.GK8670@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320683100.17809.20.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-07 at 18:22 +0200, Gleb Natapov wrote:
> > Right, so what model number do you expose? 

> Depends on what management wants. You can specify -cpu Nehalem or -cpu
> Conroe or even override model manually by doing -cpu host,model=15.

Oh cute ;-)
