Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab0LJUBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 15:01:17 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:45819
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756900Ab0LJUAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 15:00:13 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: [PATCH 7/7] staging: hv: Convert camel cased struct fields in rndis.h to lower cases
Date: Fri, 10 Dec 2010 12:04:00 -0800
Message-Id: <1292011440-21174-7-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1292011440-21174-6-git-send-email-haiyangz@microsoft.com>
References: <1292011440-21174-1-git-send-email-haiyangz@microsoft.com>
 <1292011440-21174-2-git-send-email-haiyangz@microsoft.com>
 <1292011440-21174-3-git-send-email-haiyangz@microsoft.com>
 <1292011440-21174-4-git-send-email-haiyangz@microsoft.com>
 <1292011440-21174-5-git-send-email-haiyangz@microsoft.com>
 <1292011440-21174-6-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/rndis.h        |  353 +++++++++++++++++++------------------
 drivers/staging/hv/rndis_filter.c |  204 +++++++++++-----------
 2 files changed, 279 insertions(+), 278 deletions(-)

diff --git a/drivers/staging/hv/rndis.h b/drivers/staging/hv/rndis.h
index 723e1f1..014de04 100644
--- a/drivers/staging/hv/rndis.h
+++ b/drivers/staging/hv/rndis.h
@@ -288,24 +288,24 @@
 #define RNDIS_DF_RAW_DATA			0x00000004
 
 /*  Remote NDIS medium types. */
-#define RNdisMedium802_3			0x00000000
-#define RNdisMedium802_5			0x00000001
-#define RNdisMediumFddi				0x00000002
-#define RNdisMediumWan				0x00000003
-#define RNdisMediumLocalTalk			0x00000004
-#define RNdisMediumArcnetRaw			0x00000006
-#define RNdisMediumArcnet878_2			0x00000007
-#define RNdisMediumAtm				0x00000008
-#define RNdisMediumWirelessWan			0x00000009
-#define RNdisMediumIrda				0x0000000a
-#define RNdisMediumCoWan			0x0000000b
+#define RNDIS_MEDIUM_802_3			0x00000000
+#define RNDIS_MEDIUM_802_5			0x00000001
+#define RNDIS_MEDIUM_FDDI				0x00000002
+#define RNDIS_MEDIUM_WAN				0x00000003
+#define RNDIS_MEDIUM_LOCAL_TALK			0x00000004
+#define RNDIS_MEDIUM_ARCNET_RAW			0x00000006
+#define RNDIS_MEDIUM_ARCNET_878_2			0x00000007
+#define RNDIS_MEDIUM_ATM				0x00000008
+#define RNDIS_MEDIUM_WIRELESS_WAN			0x00000009
+#define RNDIS_MEDIUM_IRDA				0x0000000a
+#define RNDIS_MEDIUM_CO_WAN			0x0000000b
 /* Not a real medium, defined as an upper-bound */
-#define RNdisMediumMax				0x0000000d
+#define RNDIS_MEDIUM_MAX				0x0000000d
 
 
 /* Remote NDIS medium connection states. */
-#define RNdisMediaStateConnected		0x00000000
-#define RNdisMediaStateDisconnected		0x00000001
+#define RNDIS_MEDIA_STATE_CONNECTED		0x00000000
+#define RNDIS_MEDIA_STATE_DISCONNECTED		0x00000001
 
 /*  Remote NDIS version numbers */
 #define RNDIS_MAJOR_VERSION			0x00000001
@@ -314,106 +314,106 @@
 
 /* NdisInitialize message */
 struct rndis_initialize_request {
-	u32 RequestId;
-	u32 MajorVersion;
-	u32 MinorVersion;
-	u32 MaxTransferSize;
+	u32 req_id;
+	u32 major_ver;
+	u32 minor_ver;
+	u32 max_xfer_size;
 };
 
 /* Response to NdisInitialize */
 struct rndis_initialize_complete {
-	u32 RequestId;
-	u32 Status;
-	u32 MajorVersion;
-	u32 MinorVersion;
-	u32 DeviceFlags;
-	u32 Medium;
-	u32 MaxPacketsPerMessage;
-	u32 MaxTransferSize;
-	u32 PacketAlignmentFactor;
-	u32 AFListOffset;
-	u32 AFListSize;
+	u32 req_id;
+	u32 status;
+	u32 major_ver;
+	u32 minor_ver;
+	u32 dev_flags;
+	u32 medium;
+	u32 max_pkt_per_msg;
+	u32 max_xfer_size;
+	u32 pkt_alignment_factor;
+	u32 af_list_offset;
+	u32 af_list_size;
 };
 
 /* Call manager devices only: Information about an address family */
 /* supported by the device is appended to the response to NdisInitialize. */
 struct rndis_co_address_family {
-	u32 AddressFamily;
-	u32 MajorVersion;
-	u32 MinorVersion;
+	u32 address_family;
+	u32 major_ver;
+	u32 minor_ver;
 };
 
 /* NdisHalt message */
 struct rndis_halt_request {
-	u32 RequestId;
+	u32 req_id;
 };
 
 /* NdisQueryRequest message */
 struct rndis_query_request {
-	u32 RequestId;
-	u32 Oid;
-	u32 InformationBufferLength;
-	u32 InformationBufferOffset;
-	u32 DeviceVcHandle;
+	u32 req_id;
+	u32 oid;
+	u32 info_buflen;
+	u32 info_buf_offset;
+	u32 dev_vc_handle;
 };
 
 /* Response to NdisQueryRequest */
 struct rndis_query_complete {
-	u32 RequestId;
-	u32 Status;
-	u32 InformationBufferLength;
-	u32 InformationBufferOffset;
+	u32 req_id;
+	u32 status;
+	u32 info_buflen;
+	u32 info_buf_offset;
 };
 
 /* NdisSetRequest message */
 struct rndis_set_request {
-	u32 RequestId;
-	u32 Oid;
-	u32 InformationBufferLength;
-	u32 InformationBufferOffset;
-	u32 DeviceVcHandle;
+	u32 req_id;
+	u32 oid;
+	u32 info_buflen;
+	u32 info_buf_offset;
+	u32 dev_vc_handle;
 };
 
 /* Response to NdisSetRequest */
 struct rndis_set_complete {
-	u32 RequestId;
-	u32 Status;
+	u32 req_id;
+	u32 status;
 };
 
 /* NdisReset message */
 struct rndis_reset_request {
-	u32 Reserved;
+	u32 reserved;
 };
 
 /* Response to NdisReset */
 struct rndis_reset_complete {
-	u32 Status;
-	u32 AddressingReset;
+	u32 status;
+	u32 addressing_reset;
 };
 
 /* NdisMIndicateStatus message */
 struct rndis_indicate_status {
-	u32 Status;
-	u32 StatusBufferLength;
-	u32 StatusBufferOffset;
+	u32 status;
+	u32 status_buflen;
+	u32 status_buf_offset;
 };
 
 /* Diagnostic information passed as the status buffer in */
 /* struct rndis_indicate_status messages signifying error conditions. */
 struct rndis_diagnostic_info {
-	u32 DiagStatus;
-	u32 ErrorOffset;
+	u32 diag_status;
+	u32 error_offset;
 };
 
 /* NdisKeepAlive message */
 struct rndis_keepalive_request {
-	u32 RequestId;
+	u32 req_id;
 };
 
 /* Response to NdisKeepAlive */
 struct rndis_keepalive_complete {
-	u32 RequestId;
-	u32 Status;
+	u32 req_id;
+	u32 status;
 };
 
 /*
@@ -422,39 +422,39 @@ struct rndis_keepalive_complete {
  * to 0 for connectionless data, otherwise it contains the VC handle.
  */
 struct rndis_packet {
-	u32 DataOffset;
-	u32 DataLength;
-	u32 OOBDataOffset;
-	u32 OOBDataLength;
-	u32 NumOOBDataElements;
-	u32 PerPacketInfoOffset;
-	u32 PerPacketInfoLength;
-	u32 VcHandle;
-	u32 Reserved;
+	u32 data_offset;
+	u32 data_len;
+	u32 oob_data_offset;
+	u32 oob_data_len;
+	u32 num_oob_data_elements;
+	u32 per_pkt_info_offset;
+	u32 per_pkt_info_len;
+	u32 vc_handle;
+	u32 reserved;
 };
 
 /* Optional Out of Band data associated with a Data message. */
 struct rndis_oobd {
-	u32 Size;
-	u32 Type;
-	u32 ClassInformationOffset;
+	u32 size;
+	u32 type;
+	u32 class_info_offset;
 };
 
 /* Packet extension field contents associated with a Data message. */
 struct rndis_per_packet_info {
-	u32 Size;
-	u32 Type;
-	u32 PerPacketInformationOffset;
+	u32 size;
+	u32 type;
+	u32 per_pkt_info_offset;
 };
 
 /* Format of Information buffer passed in a SetRequest for the OID */
 /* OID_GEN_RNDIS_CONFIG_PARAMETER. */
 struct rndis_config_parameter_info {
-	u32 ParameterNameOffset;
-	u32 ParameterNameLength;
-	u32 ParameterType;
-	u32 ParameterValueOffset;
-	u32 ParameterValueLength;
+	u32 parameter_name_offset;
+	u32 parameter_name_length;
+	u32 parameter_type;
+	u32 parameter_value_offset;
+	u32 parameter_value_length;
 };
 
 /* Values for ParameterType in struct rndis_config_parameter_info */
@@ -466,187 +466,188 @@ struct rndis_config_parameter_info {
 
 /* CoNdisMiniportCreateVc message */
 struct rcondis_mp_create_vc {
-	u32 RequestId;
-	u32 NdisVcHandle;
+	u32 req_id;
+	u32 ndis_vc_handle;
 };
 
 /* Response to CoNdisMiniportCreateVc */
 struct rcondis_mp_create_vc_complete {
-	u32 RequestId;
-	u32 DeviceVcHandle;
-	u32 Status;
+	u32 req_id;
+	u32 dev_vc_handle;
+	u32 status;
 };
 
 /* CoNdisMiniportDeleteVc message */
 struct rcondis_mp_delete_vc {
-	u32 RequestId;
-	u32 DeviceVcHandle;
+	u32 req_id;
+	u32 dev_vc_handle;
 };
 
 /* Response to CoNdisMiniportDeleteVc */
 struct rcondis_mp_delete_vc_complete {
-	u32 RequestId;
-	u32 Status;
+	u32 req_id;
+	u32 status;
 };
 
 /* CoNdisMiniportQueryRequest message */
 struct rcondis_mp_query_request {
-	u32 RequestId;
-	u32 RequestType;
-	u32 Oid;
-	u32 DeviceVcHandle;
-	u32 InformationBufferLength;
-	u32 InformationBufferOffset;
+	u32 req_id;
+	u32 request_type;
+	u32 oid;
+	u32 dev_vc_handle;
+	u32 info_buflen;
+	u32 info_buf_offset;
 };
 
 /* CoNdisMiniportSetRequest message */
 struct rcondis_mp_set_request {
-	u32 RequestId;
-	u32 RequestType;
-	u32 Oid;
-	u32 DeviceVcHandle;
-	u32 InformationBufferLength;
-	u32 InformationBufferOffset;
+	u32 req_id;
+	u32 request_type;
+	u32 oid;
+	u32 dev_vc_handle;
+	u32 info_buflen;
+	u32 info_buf_offset;
 };
 
 /* CoNdisIndicateStatus message */
 struct rcondis_indicate_status {
-	u32 NdisVcHandle;
-	u32 Status;
-	u32 StatusBufferLength;
-	u32 StatusBufferOffset;
+	u32 ndis_vc_handle;
+	u32 status;
+	u32 status_buflen;
+	u32 status_buf_offset;
 };
 
 /* CONDIS Call/VC parameters */
 struct rcondis_specific_parameters {
-	u32 ParameterType;
-	u32 ParameterLength;
-	u32 ParameterOffset;
+	u32 parameter_type;
+	u32 parameter_length;
+	u32 parameter_lffset;
 };
 
 struct rcondis_media_parameters {
-	u32 Flags;
-	u32 Reserved1;
-	u32 Reserved2;
-	struct rcondis_specific_parameters MediaSpecific;
+	u32 flags;
+	u32 reserved1;
+	u32 reserved2;
+	struct rcondis_specific_parameters media_specific;
 };
 
 struct rndis_flowspec {
-	u32 TokenRate;
-	u32 TokenBucketSize;
-	u32 PeakBandwidth;
-	u32 Latency;
-	u32 DelayVariation;
-	u32 ServiceType;
-	u32 MaxSduSize;
-	u32 MinimumPolicedSize;
+	u32 token_rate;
+	u32 token_bucket_size;
+	u32 peak_bandwidth;
+	u32 latency;
+	u32 delay_variation;
+	u32 service_type;
+	u32 max_sdu_size;
+	u32 minimum_policed_size;
 };
 
 struct rcondis_call_manager_parameters {
-	struct rndis_flowspec Transmit;
-	struct rndis_flowspec Receive;
-	struct rcondis_specific_parameters CallMgrSpecific;
+	struct rndis_flowspec transmit;
+	struct rndis_flowspec receive;
+	struct rcondis_specific_parameters call_mgr_specific;
 };
 
 /* CoNdisMiniportActivateVc message */
 struct rcondis_mp_activate_vc_request {
-	u32 RequestId;
-	u32 Flags;
-	u32 DeviceVcHandle;
-	u32 MediaParamsOffset;
-	u32 MediaParamsLength;
-	u32 CallMgrParamsOffset;
-	u32 CallMgrParamsLength;
+	u32 req_id;
+	u32 flags;
+	u32 dev_vc_handle;
+	u32 media_params_offset;
+	u32 media_params_length;
+	u32 call_mgr_params_offset;
+	u32 call_mgr_params_length;
 };
 
 /* Response to CoNdisMiniportActivateVc */
 struct rcondis_mp_activate_vc_complete {
-	u32 RequestId;
-	u32 Status;
+	u32 req_id;
+	u32 status;
 };
 
 /* CoNdisMiniportDeactivateVc message */
 struct rcondis_mp_deactivate_vc_request {
-	u32 RequestId;
-	u32 Flags;
-	u32 DeviceVcHandle;
+	u32 req_id;
+	u32 flags;
+	u32 dev_vc_handle;
 };
 
 /* Response to CoNdisMiniportDeactivateVc */
 struct rcondis_mp_deactivate_vc_complete {
-	u32 RequestId;
-	u32 Status;
+	u32 req_id;
+	u32 status;
 };
 
 
 /* union with all of the RNDIS messages */
 union rndis_message_container {
-	struct rndis_packet Packet;
-	struct rndis_initialize_request InitializeRequest;
-	struct rndis_halt_request HaltRequest;
-	struct rndis_query_request QueryRequest;
-	struct rndis_set_request SetRequest;
-	struct rndis_reset_request ResetRequest;
-	struct rndis_keepalive_request KeepaliveRequest;
-	struct rndis_indicate_status IndicateStatus;
-	struct rndis_initialize_complete InitializeComplete;
-	struct rndis_query_complete QueryComplete;
-	struct rndis_set_complete SetComplete;
-	struct rndis_reset_complete ResetComplete;
-	struct rndis_keepalive_complete KeepaliveComplete;
-	struct rcondis_mp_create_vc CoMiniportCreateVc;
-	struct rcondis_mp_delete_vc CoMiniportDeleteVc;
-	struct rcondis_indicate_status CoIndicateStatus;
-	struct rcondis_mp_activate_vc_request CoMiniportActivateVc;
-	struct rcondis_mp_deactivate_vc_request CoMiniportDeactivateVc;
-	struct rcondis_mp_create_vc_complete CoMiniportCreateVcComplete;
-	struct rcondis_mp_delete_vc_complete CoMiniportDeleteVcComplete;
-	struct rcondis_mp_activate_vc_complete CoMiniportActivateVcComplete;
-	struct rcondis_mp_deactivate_vc_complete CoMiniportDeactivateVcComplete;
+	struct rndis_packet pkt;
+	struct rndis_initialize_request init_req;
+	struct rndis_halt_request halt_req;
+	struct rndis_query_request query_req;
+	struct rndis_set_request set_req;
+	struct rndis_reset_request reset_req;
+	struct rndis_keepalive_request keep_alive_req;
+	struct rndis_indicate_status indicate_status;
+	struct rndis_initialize_complete init_complete;
+	struct rndis_query_complete query_complete;
+	struct rndis_set_complete set_complete;
+	struct rndis_reset_complete reset_complete;
+	struct rndis_keepalive_complete keep_alive_complete;
+	struct rcondis_mp_create_vc co_miniport_create_vc;
+	struct rcondis_mp_delete_vc co_miniport_delete_vc;
+	struct rcondis_indicate_status co_indicate_status;
+	struct rcondis_mp_activate_vc_request co_miniport_activate_vc;
+	struct rcondis_mp_deactivate_vc_request co_miniport_deactivate_vc;
+	struct rcondis_mp_create_vc_complete co_miniport_create_vc_complete;
+	struct rcondis_mp_delete_vc_complete co_miniport_delete_vc_complete;
+	struct rcondis_mp_activate_vc_complete co_miniport_activate_vc_complete;
+	struct rcondis_mp_deactivate_vc_complete
+		co_miniport_deactivate_vc_complete;
 };
 
 /* Remote NDIS message format */
 struct rndis_message {
-	u32 NdisMessageType;
+	u32 ndis_msg_type;
 
 	/* Total length of this message, from the beginning */
 	/* of the sruct rndis_message, in bytes. */
-	u32 MessageLength;
+	u32 msg_len;
 
 	/* Actual message */
-	union rndis_message_container Message;
+	union rndis_message_container msg;
 };
 
 /* Handy macros */
 
 /* get the size of an RNDIS message. Pass in the message type, */
 /* struct rndis_set_request, struct rndis_packet for example */
-#define RNDIS_MESSAGE_SIZE(Message)				\
-	(sizeof(Message) + (sizeof(struct rndis_message) -	\
+#define RNDIS_MESSAGE_SIZE(msg)				\
+	(sizeof(msg) + (sizeof(struct rndis_message) -	\
 	 sizeof(union rndis_message_container)))
 
 /* get pointer to info buffer with message pointer */
-#define MESSAGE_TO_INFO_BUFFER(Message)				\
-	(((unsigned char *)(Message)) + Message->InformationBufferOffset)
+#define MESSAGE_TO_INFO_BUFFER(msg)				\
+	(((unsigned char *)(msg)) + msg->info_buf_offset)
 
 /* get pointer to status buffer with message pointer */
-#define MESSAGE_TO_STATUS_BUFFER(Message)			\
-	(((unsigned char *)(Message)) + Message->StatusBufferOffset)
+#define MESSAGE_TO_STATUS_BUFFER(msg)			\
+	(((unsigned char *)(msg)) + msg->status_buf_offset)
 
 /* get pointer to OOBD buffer with message pointer */
-#define MESSAGE_TO_OOBD_BUFFER(Message)				\
-	(((unsigned char *)(Message)) + Message->OOBDataOffset)
+#define MESSAGE_TO_OOBD_BUFFER(msg)				\
+	(((unsigned char *)(msg)) + msg->oob_data_offset)
 
 /* get pointer to data buffer with message pointer */
-#define MESSAGE_TO_DATA_BUFFER(Message)				\
-	(((unsigned char *)(Message)) + Message->PerPacketInfoOffset)
+#define MESSAGE_TO_DATA_BUFFER(msg)				\
+	(((unsigned char *)(msg)) + msg->per_pkt_info_offset)
 
 /* get pointer to contained message from NDIS_MESSAGE pointer */
-#define RNDIS_MESSAGE_PTR_TO_MESSAGE_PTR(RndisMessage)		\
-	((void *) &RndisMessage->Message)
+#define RNDIS_MESSAGE_PTR_TO_MESSAGE_PTR(rndis_msg)		\
+	((void *) &rndis_msg->msg)
 
 /* get pointer to contained message from NDIS_MESSAGE pointer */
-#define RNDIS_MESSAGE_RAW_PTR_TO_MESSAGE_PTR(RndisMessage)	\
-	((void *) RndisMessage)
+#define RNDIS_MESSAGE_RAW_PTR_TO_MESSAGE_PTR(rndis_msg)	\
+	((void *) rndis_msg)
 
 #endif /* _RNDIS_H_ */
diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index 63d24c6..53676dc 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -136,16 +136,16 @@ static struct rndis_request *get_rndis_request(struct rndis_device *dev,
 	}
 
 	rndis_msg = &request->request_msg;
-	rndis_msg->NdisMessageType = msg_type;
-	rndis_msg->MessageLength = msg_len;
+	rndis_msg->ndis_msg_type = msg_type;
+	rndis_msg->msg_len = msg_len;
 
 	/*
 	 * Set the request id. This field is always after the rndis header for
 	 * request/response packet types so we just used the SetRequest as a
 	 * template
 	 */
-	set = &rndis_msg->Message.SetRequest;
-	set->RequestId = atomic_inc_return(&dev->new_req_id);
+	set = &rndis_msg->msg.set_req;
+	set->req_id = atomic_inc_return(&dev->new_req_id);
 
 	/* Add to the request list */
 	spin_lock_irqsave(&dev->request_lock, flags);
@@ -170,20 +170,20 @@ static void put_rndis_request(struct rndis_device *dev,
 
 static void dump_rndis_message(struct rndis_message *rndis_msg)
 {
-	switch (rndis_msg->NdisMessageType) {
+	switch (rndis_msg->ndis_msg_type) {
 	case REMOTE_NDIS_PACKET_MSG:
 		DPRINT_DBG(NETVSC, "REMOTE_NDIS_PACKET_MSG (len %u, "
 			   "data offset %u data len %u, # oob %u, "
 			   "oob offset %u, oob len %u, pkt offset %u, "
 			   "pkt len %u",
-			   rndis_msg->MessageLength,
-			   rndis_msg->Message.Packet.DataOffset,
-			   rndis_msg->Message.Packet.DataLength,
-			   rndis_msg->Message.Packet.NumOOBDataElements,
-			   rndis_msg->Message.Packet.OOBDataOffset,
-			   rndis_msg->Message.Packet.OOBDataLength,
-			   rndis_msg->Message.Packet.PerPacketInfoOffset,
-			   rndis_msg->Message.Packet.PerPacketInfoLength);
+			   rndis_msg->msg_len,
+			   rndis_msg->msg.pkt.data_offset,
+			   rndis_msg->msg.pkt.data_len,
+			   rndis_msg->msg.pkt.num_oob_data_elements,
+			   rndis_msg->msg.pkt.oob_data_offset,
+			   rndis_msg->msg.pkt.oob_data_len,
+			   rndis_msg->msg.pkt.per_pkt_info_offset,
+			   rndis_msg->msg.pkt.per_pkt_info_len);
 		break;
 
 	case REMOTE_NDIS_INITIALIZE_CMPLT:
@@ -191,53 +191,53 @@ static void dump_rndis_message(struct rndis_message *rndis_msg)
 			"(len %u, id 0x%x, status 0x%x, major %d, minor %d, "
 			"device flags %d, max xfer size 0x%x, max pkts %u, "
 			"pkt aligned %u)",
-			rndis_msg->MessageLength,
-			rndis_msg->Message.InitializeComplete.RequestId,
-			rndis_msg->Message.InitializeComplete.Status,
-			rndis_msg->Message.InitializeComplete.MajorVersion,
-			rndis_msg->Message.InitializeComplete.MinorVersion,
-			rndis_msg->Message.InitializeComplete.DeviceFlags,
-			rndis_msg->Message.InitializeComplete.MaxTransferSize,
-			rndis_msg->Message.InitializeComplete.
-			   MaxPacketsPerMessage,
-			rndis_msg->Message.InitializeComplete.
-			   PacketAlignmentFactor);
+			rndis_msg->msg_len,
+			rndis_msg->msg.init_complete.req_id,
+			rndis_msg->msg.init_complete.status,
+			rndis_msg->msg.init_complete.major_ver,
+			rndis_msg->msg.init_complete.minor_ver,
+			rndis_msg->msg.init_complete.dev_flags,
+			rndis_msg->msg.init_complete.max_xfer_size,
+			rndis_msg->msg.init_complete.
+			   max_pkt_per_msg,
+			rndis_msg->msg.init_complete.
+			   pkt_alignment_factor);
 		break;
 
 	case REMOTE_NDIS_QUERY_CMPLT:
 		DPRINT_DBG(NETVSC, "REMOTE_NDIS_QUERY_CMPLT "
 			"(len %u, id 0x%x, status 0x%x, buf len %u, "
 			"buf offset %u)",
-			rndis_msg->MessageLength,
-			rndis_msg->Message.QueryComplete.RequestId,
-			rndis_msg->Message.QueryComplete.Status,
-			rndis_msg->Message.QueryComplete.
-			   InformationBufferLength,
-			rndis_msg->Message.QueryComplete.
-			   InformationBufferOffset);
+			rndis_msg->msg_len,
+			rndis_msg->msg.query_complete.req_id,
+			rndis_msg->msg.query_complete.status,
+			rndis_msg->msg.query_complete.
+			   info_buflen,
+			rndis_msg->msg.query_complete.
+			   info_buf_offset);
 		break;
 
 	case REMOTE_NDIS_SET_CMPLT:
 		DPRINT_DBG(NETVSC,
 			"REMOTE_NDIS_SET_CMPLT (len %u, id 0x%x, status 0x%x)",
-			rndis_msg->MessageLength,
-			rndis_msg->Message.SetComplete.RequestId,
-			rndis_msg->Message.SetComplete.Status);
+			rndis_msg->msg_len,
+			rndis_msg->msg.set_complete.req_id,
+			rndis_msg->msg.set_complete.status);
 		break;
 
 	case REMOTE_NDIS_INDICATE_STATUS_MSG:
 		DPRINT_DBG(NETVSC, "REMOTE_NDIS_INDICATE_STATUS_MSG "
 			"(len %u, status 0x%x, buf len %u, buf offset %u)",
-			rndis_msg->MessageLength,
-			rndis_msg->Message.IndicateStatus.Status,
-			rndis_msg->Message.IndicateStatus.StatusBufferLength,
-			rndis_msg->Message.IndicateStatus.StatusBufferOffset);
+			rndis_msg->msg_len,
+			rndis_msg->msg.indicate_status.status,
+			rndis_msg->msg.indicate_status.status_buflen,
+			rndis_msg->msg.indicate_status.status_buf_offset);
 		break;
 
 	default:
 		DPRINT_DBG(NETVSC, "0x%x (len %u)",
-			rndis_msg->NdisMessageType,
-			rndis_msg->MessageLength);
+			rndis_msg->ndis_msg_type,
+			rndis_msg->msg_len);
 		break;
 	}
 }
@@ -252,12 +252,12 @@ static int rndis_filter_send_request(struct rndis_device *dev,
 	packet = &req->pkt;
 
 	packet->is_data_pkt = false;
-	packet->total_data_buflen = req->request_msg.MessageLength;
+	packet->total_data_buflen = req->request_msg.msg_len;
 	packet->page_buf_cnt = 1;
 
 	packet->page_buf[0].Pfn = virt_to_phys(&req->request_msg) >>
 					PAGE_SHIFT;
-	packet->page_buf[0].Length = req->request_msg.MessageLength;
+	packet->page_buf[0].Length = req->request_msg.msg_len;
 	packet->page_buf[0].Offset =
 		(unsigned long)&req->request_msg & (PAGE_SIZE - 1);
 
@@ -283,15 +283,15 @@ static void rndis_filter_receive_response(struct rndis_device *dev,
 		 * All request/response message contains RequestId as the 1st
 		 * field
 		 */
-		if (request->request_msg.Message.InitializeRequest.RequestId
-		    == resp->Message.InitializeComplete.RequestId) {
+		if (request->request_msg.msg.init_req.req_id
+		    == resp->msg.init_complete.req_id) {
 			DPRINT_DBG(NETVSC, "found rndis request for "
 				"this response (id 0x%x req type 0x%x res "
 				"type 0x%x)",
-				request->request_msg.Message.
-				   InitializeRequest.RequestId,
-				request->request_msg.NdisMessageType,
-				resp->NdisMessageType);
+				request->request_msg.msg.
+				   init_req.req_id,
+				request->request_msg.ndis_msg_type,
+				resp->ndis_msg_type);
 
 			found = true;
 			break;
@@ -300,23 +300,23 @@ static void rndis_filter_receive_response(struct rndis_device *dev,
 	spin_unlock_irqrestore(&dev->request_lock, flags);
 
 	if (found) {
-		if (resp->MessageLength <= sizeof(struct rndis_message)) {
+		if (resp->msg_len <= sizeof(struct rndis_message)) {
 			memcpy(&request->response_msg, resp,
-			       resp->MessageLength);
+			       resp->msg_len);
 		} else {
 			DPRINT_ERR(NETVSC, "rndis response buffer overflow "
 				  "detected (size %u max %zu)",
-				  resp->MessageLength,
+				  resp->msg_len,
 				  sizeof(struct rndis_filter_packet));
 
-			if (resp->NdisMessageType ==
+			if (resp->ndis_msg_type ==
 			    REMOTE_NDIS_RESET_CMPLT) {
 				/* does not have a request id field */
-				request->response_msg.Message.ResetComplete.
-					Status = STATUS_BUFFER_OVERFLOW;
+				request->response_msg.msg.reset_complete.
+					status = STATUS_BUFFER_OVERFLOW;
 			} else {
-				request->response_msg.Message.
-				InitializeComplete.Status =
+				request->response_msg.msg.
+				init_complete.status =
 					STATUS_BUFFER_OVERFLOW;
 			}
 		}
@@ -325,8 +325,8 @@ static void rndis_filter_receive_response(struct rndis_device *dev,
 	} else {
 		DPRINT_ERR(NETVSC, "no rndis request found for this response "
 			   "(id 0x%x res type 0x%x)",
-			   resp->Message.InitializeComplete.RequestId,
-			   resp->NdisMessageType);
+			   resp->msg.init_complete.req_id,
+			   resp->ndis_msg_type);
 	}
 }
 
@@ -334,12 +334,12 @@ static void rndis_filter_receive_indicate_status(struct rndis_device *dev,
 					     struct rndis_message *resp)
 {
 	struct rndis_indicate_status *indicate =
-			&resp->Message.IndicateStatus;
+			&resp->msg.indicate_status;
 
-	if (indicate->Status == RNDIS_STATUS_MEDIA_CONNECT) {
+	if (indicate->status == RNDIS_STATUS_MEDIA_CONNECT) {
 		rndis_filter.inner_drv.link_status_change(
 			dev->net_dev->dev, 1);
-	} else if (indicate->Status == RNDIS_STATUS_MEDIA_DISCONNECT) {
+	} else if (indicate->status == RNDIS_STATUS_MEDIA_DISCONNECT) {
 		rndis_filter.inner_drv.link_status_change(
 			dev->net_dev->dev, 0);
 	} else {
@@ -360,7 +360,7 @@ static void rndis_filter_receive_data(struct rndis_device *dev,
 	/* ASSERT(Packet->PageBuffers[0].Length > */
 	/* 	RNDIS_MESSAGE_SIZE(struct rndis_packet)); */
 
-	rndis_pkt = &msg->Message.Packet;
+	rndis_pkt = &msg->msg.pkt;
 
 	/*
 	 * FIXME: Handle multiple rndis pkt msgs that maybe enclosed in this
@@ -368,7 +368,7 @@ static void rndis_filter_receive_data(struct rndis_device *dev,
 	 */
 
 	/* Remove the rndis header and pass it back up the stack */
-	data_offset = RNDIS_HEADER_SIZE + rndis_pkt->DataOffset;
+	data_offset = RNDIS_HEADER_SIZE + rndis_pkt->data_offset;
 
 	pkt->total_data_buflen -= data_offset;
 	pkt->page_buf[0].Offset += data_offset;
@@ -418,36 +418,36 @@ static int rndis_filter_receive(struct hv_device *dev,
 	 * range shows 52 bytes
 	 * */
 #if 0
-	if (pkt->total_data_buflen != rndis_hdr->MessageLength) {
+	if (pkt->total_data_buflen != rndis_hdr->msg_len) {
 		kunmap_atomic(rndis_hdr - pkt->page_buf[0].Offset,
 			      KM_IRQ0);
 
 		DPRINT_ERR(NETVSC, "invalid rndis message? (expected %u "
 			   "bytes got %u)...dropping this message!",
-			   rndis_hdr->MessageLength,
+			   rndis_hdr->msg_len,
 			   pkt->total_data_buflen);
 		return -1;
 	}
 #endif
 
-	if ((rndis_hdr->NdisMessageType != REMOTE_NDIS_PACKET_MSG) &&
-	    (rndis_hdr->MessageLength > sizeof(struct rndis_message))) {
+	if ((rndis_hdr->ndis_msg_type != REMOTE_NDIS_PACKET_MSG) &&
+	    (rndis_hdr->msg_len > sizeof(struct rndis_message))) {
 		DPRINT_ERR(NETVSC, "incoming rndis message buffer overflow "
 			   "detected (got %u, max %zu)...marking it an error!",
-			   rndis_hdr->MessageLength,
+			   rndis_hdr->msg_len,
 			   sizeof(struct rndis_message));
 	}
 
 	memcpy(&rndis_msg, rndis_hdr,
-		(rndis_hdr->MessageLength > sizeof(struct rndis_message)) ?
+		(rndis_hdr->msg_len > sizeof(struct rndis_message)) ?
 			sizeof(struct rndis_message) :
-			rndis_hdr->MessageLength);
+			rndis_hdr->msg_len);
 
 	kunmap_atomic(rndis_hdr - pkt->page_buf[0].Offset, KM_IRQ0);
 
 	dump_rndis_message(&rndis_msg);
 
-	switch (rndis_msg.NdisMessageType) {
+	switch (rndis_msg.ndis_msg_type) {
 	case REMOTE_NDIS_PACKET_MSG:
 		/* data msg */
 		rndis_filter_receive_data(rndis_dev, &rndis_msg, pkt);
@@ -468,8 +468,8 @@ static int rndis_filter_receive(struct hv_device *dev,
 		break;
 	default:
 		DPRINT_ERR(NETVSC, "unhandled rndis message (type %u len %u)",
-			   rndis_msg.NdisMessageType,
-			   rndis_msg.MessageLength);
+			   rndis_msg.ndis_msg_type,
+			   rndis_msg.msg_len);
 		break;
 	}
 
@@ -497,11 +497,11 @@ static int rndis_filter_query_device(struct rndis_device *dev, u32 oid,
 	}
 
 	/* Setup the rndis query */
-	query = &request->request_msg.Message.QueryRequest;
-	query->Oid = oid;
-	query->InformationBufferOffset = sizeof(struct rndis_query_request);
-	query->InformationBufferLength = 0;
-	query->DeviceVcHandle = 0;
+	query = &request->request_msg.msg.query_req;
+	query->oid = oid;
+	query->info_buf_offset = sizeof(struct rndis_query_request);
+	query->info_buflen = 0;
+	query->dev_vc_handle = 0;
 
 	ret = rndis_filter_send_request(dev, request);
 	if (ret != 0)
@@ -510,19 +510,19 @@ static int rndis_filter_query_device(struct rndis_device *dev, u32 oid,
 	osd_waitevent_wait(request->waitevent);
 
 	/* Copy the response back */
-	query_complete = &request->response_msg.Message.QueryComplete;
+	query_complete = &request->response_msg.msg.query_complete;
 
-	if (query_complete->InformationBufferLength > inresult_size) {
+	if (query_complete->info_buflen > inresult_size) {
 		ret = -1;
 		goto Cleanup;
 	}
 
 	memcpy(result,
 	       (void *)((unsigned long)query_complete +
-			 query_complete->InformationBufferOffset),
-	       query_complete->InformationBufferLength);
+			 query_complete->info_buf_offset),
+	       query_complete->info_buflen);
 
-	*result_size = query_complete->InformationBufferLength;
+	*result_size = query_complete->info_buflen;
 
 Cleanup:
 	if (request)
@@ -570,10 +570,10 @@ static int rndis_filter_set_packet_filter(struct rndis_device *dev,
 	}
 
 	/* Setup the rndis set */
-	set = &request->request_msg.Message.SetRequest;
-	set->Oid = RNDIS_OID_GEN_CURRENT_PACKET_FILTER;
-	set->InformationBufferLength = sizeof(u32);
-	set->InformationBufferOffset = sizeof(struct rndis_set_request);
+	set = &request->request_msg.msg.set_req;
+	set->oid = RNDIS_OID_GEN_CURRENT_PACKET_FILTER;
+	set->info_buflen = sizeof(u32);
+	set->info_buf_offset = sizeof(struct rndis_set_request);
 
 	memcpy((void *)(unsigned long)set + sizeof(struct rndis_set_request),
 	       &new_filter, sizeof(u32));
@@ -594,8 +594,8 @@ static int rndis_filter_set_packet_filter(struct rndis_device *dev,
 	} else {
 		if (ret > 0)
 			ret = 0;
-		set_complete = &request->response_msg.Message.SetComplete;
-		status = set_complete->Status;
+		set_complete = &request->response_msg.msg.set_complete;
+		status = set_complete->status;
 	}
 
 Cleanup:
@@ -661,11 +661,11 @@ static int rndis_filter_init_device(struct rndis_device *dev)
 	}
 
 	/* Setup the rndis set */
-	init = &request->request_msg.Message.InitializeRequest;
-	init->MajorVersion = RNDIS_MAJOR_VERSION;
-	init->MinorVersion = RNDIS_MINOR_VERSION;
+	init = &request->request_msg.msg.init_req;
+	init->major_ver = RNDIS_MAJOR_VERSION;
+	init->minor_ver = RNDIS_MINOR_VERSION;
 	/* FIXME: Use 1536 - rounded ethernet frame size */
-	init->MaxTransferSize = 2048;
+	init->max_xfer_size = 2048;
 
 	dev->state = RNDIS_DEV_INITIALIZING;
 
@@ -677,8 +677,8 @@ static int rndis_filter_init_device(struct rndis_device *dev)
 
 	osd_waitevent_wait(request->waitevent);
 
-	init_complete = &request->response_msg.Message.InitializeComplete;
-	status = init_complete->Status;
+	init_complete = &request->response_msg.msg.init_complete;
+	status = init_complete->status;
 	if (status == RNDIS_STATUS_SUCCESS) {
 		dev->state = RNDIS_DEV_INITIALIZED;
 		ret = 0;
@@ -706,8 +706,8 @@ static void rndis_filter_halt_device(struct rndis_device *dev)
 		goto Cleanup;
 
 	/* Setup the rndis set */
-	halt = &request->request_msg.Message.HaltRequest;
-	halt->RequestId = atomic_inc_return(&dev->new_req_id);
+	halt = &request->request_msg.msg.halt_req;
+	halt->req_id = atomic_inc_return(&dev->new_req_id);
 
 	/* Ignore return since this msg is optional. */
 	rndis_filter_send_request(dev, request);
@@ -875,13 +875,13 @@ static int rndis_filter_send(struct hv_device *dev,
 	rndisMessage = &filterPacket->msg;
 	rndisMessageSize = RNDIS_MESSAGE_SIZE(struct rndis_packet);
 
-	rndisMessage->NdisMessageType = REMOTE_NDIS_PACKET_MSG;
-	rndisMessage->MessageLength = pkt->total_data_buflen +
+	rndisMessage->ndis_msg_type = REMOTE_NDIS_PACKET_MSG;
+	rndisMessage->msg_len = pkt->total_data_buflen +
 				      rndisMessageSize;
 
-	rndisPacket = &rndisMessage->Message.Packet;
-	rndisPacket->DataOffset = sizeof(struct rndis_packet);
-	rndisPacket->DataLength = pkt->total_data_buflen;
+	rndisPacket = &rndisMessage->msg.pkt;
+	rndisPacket->data_offset = sizeof(struct rndis_packet);
+	rndisPacket->data_len = pkt->total_data_buflen;
 
 	pkt->is_data_pkt = true;
 	pkt->page_buf[0].Pfn = virt_to_phys(rndisMessage) >> PAGE_SHIFT;
-- 
1.6.3.2

