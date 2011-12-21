Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab1LUC6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 21:58:01 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:35465 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab1LUC6A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 21:58:00 -0500
X-SpamScore: -10
X-BigFish: VS-10(zzbb2dI9371I542M1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h944hbe9n61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Rob Herring <robherring2@gmail.com>
CC: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        Guo Shawn-R65073 <r65073@freescale.com>
Subject: RE: [PATCH 1/1] dt: fix some code indent issue in of.h
Thread-Topic: [PATCH 1/1] dt: fix some code indent issue in of.h
Thread-Index: AQHMv0EPv1hJCgoXWkmCpU4WudlJA5XldDaAgAAlk3A=
Date: Wed, 21 Dec 2011 02:57:58 +0000
Message-ID: <7FE21149F4667147B645348EC605788505C492@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1324404609-3999-1-git-send-email-b29396@freescale.com>
 <4EF0D6FD.8070406@gmail.com>
In-Reply-To: <4EF0D6FD.8070406@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.198]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Rob Herring [mailto:robherring2@gmail.com]
> Sent: Wednesday, December 21, 2011 2:42 AM
> To: Dong Aisheng-B29396
> Cc: devicetree-discuss@lists.ozlabs.org; linux-kernel@vger.kernel.org; linux-
> arm-kernel@lists.infradead.org; grant.likely@secretlab.ca; Guo Shawn-R65073
> Subject: Re: [PATCH 1/1] dt: fix some code indent issue in of.h
> Importance: High
> 
> On 12/20/2011 12:10 PM, Dong Aisheng wrote:
> > From: Dong Aisheng <dong.aisheng@linaro.org>
> >
> > Checkpatch script will report some warnings for the old coding style:
> > WARNING: suspect code indent for conditional statements (8, 0)
> >         for (child = of_get_next_child(parent, NULL); child != NULL; \
> > [...]
> > +static inline int of_get_child_count(const struct device_node *np)
> >
> > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Cc: Rob Herring <rob.herring@calxeda.com>
> > ---
> >  include/linux/of.h |   12 ++++++------
> >  1 files changed, 6 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/linux/of.h b/include/linux/of.h index
> > f1a490c..95dee0a 100644
> > --- a/include/linux/of.h
> > +++ b/include/linux/of.h
> > @@ -163,22 +163,22 @@ extern struct device_node *of_find_node_by_name(struct
> device_node *from,
> >  	const char *name);
> >  #define for_each_node_by_name(dn, name) \
> >  	for (dn = of_find_node_by_name(NULL, name); dn; \
> > -	     dn = of_find_node_by_name(dn, name))
> > +		dn = of_find_node_by_name(dn, name))
> >  extern struct device_node *of_find_node_by_type(struct device_node *from,
> >  	const char *type);
> >  #define for_each_node_by_type(dn, type) \
> >  	for (dn = of_find_node_by_type(NULL, type); dn; \
> > -	     dn = of_find_node_by_type(dn, type))
> > +		dn = of_find_node_by_type(dn, type))
> >  extern struct device_node *of_find_compatible_node(struct device_node *from,
> >  	const char *type, const char *compat);  #define
> > for_each_compatible_node(dn, type, compatible) \
> >  	for (dn = of_find_compatible_node(NULL, type, compatible); dn; \
> > -	     dn = of_find_compatible_node(dn, type, compatible))
> > +		dn = of_find_compatible_node(dn, type, compatible))
> >  extern struct device_node *of_find_matching_node(struct device_node *from,
> >  	const struct of_device_id *matches);  #define
> > for_each_matching_node(dn, matches) \
> >  	for (dn = of_find_matching_node(NULL, matches); dn; \
> > -	     dn = of_find_matching_node(dn, matches))
> > +		dn = of_find_matching_node(dn, matches))
> >  extern struct device_node *of_find_node_by_path(const char *path);
> > extern struct device_node *of_find_node_by_phandle(phandle handle);
> > extern struct device_node *of_get_parent(const struct device_node
> > *node); @@ -187,13 +187,13 @@ extern struct device_node
> *of_get_next_child(const struct device_node *node,
> >  					     struct device_node *prev);
> >  #define for_each_child_of_node(parent, child) \
> >  	for (child = of_get_next_child(parent, NULL); child != NULL; \
> > -	     child = of_get_next_child(parent, child))
> > +		child = of_get_next_child(parent, child))
> >
> >  extern struct device_node *of_find_node_with_property(
> >  	struct device_node *from, const char *prop_name);  #define
> > for_each_node_with_property(dn, prop_name) \
> >  	for (dn = of_find_node_with_property(NULL, prop_name); dn; \
> > -	     dn = of_find_node_with_property(dn, prop_name))
> > +		dn = of_find_node_with_property(dn, prop_name))
> >
> >  extern struct property *of_find_property(const struct device_node *np,
> >  					 const char *name,
> 
> The old way looks fine to me and indenting like this is commonly used in the
> kernel.
> 
Yes, i was also ok without those annoying warning.
Do you think if we need to fix the checkpatch.pl if the it is commonly used
In the kernel?

Regards
Dong Aisheng


