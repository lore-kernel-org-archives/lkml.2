Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933941Ab2AKUpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 15:45:47 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:37794 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932962Ab2AKUpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 15:45:43 -0500
Date: Thu, 12 Jan 2012 05:45:39 +0900
From: Simon Horman <horms@verge.net.au>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, schwidefsky@de.ibm.com,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] kdump: Define KEXEC_NOTE_BYTES arch specific for s390x
Message-ID: <20120111204539.GB23752@verge.net.au>
References: <1326281412.2819.3.camel@br98xy6r>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326281412.2819.3.camel@br98xy6r>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 12:30:12PM +0100, Michael Holzheu wrote:
> From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> 
> kdump only allocates memory for the prstatus ELF note. For s390x,
> besides of prstatus multiple ELF notes for various different register
> types are stored. Therefore the currently allocated memory is not
> sufficient. With this patch the KEXEC_NOTE_BYTES macro can be
> defined by architecture code and for s390x it is set to the correct
> size now.
> 
> Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>

This seems reasonable to me.

Reviewed-by: Simon Horman <horms@verge.net.au>
